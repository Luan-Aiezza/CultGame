import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

class GameViewModel: ObservableObject {
    // MARK: - Estado geral do jogo
    @Published var currentPhase: GamePhase = .roleSelection {
        didSet {
            startTimer()
            handlePhaseChange()
        }
    }
    @Published var timeRemaining: Int = 30
    @Published var round: Int = 0
    @Published var activeCards: [SpecificCard] = []

    var deck = CardDeck()
    let multiplayerManager = MultiplayerManager.shared
    private var emptyCard = Card(name: "", faithCost: 0, followersEffect: 0, description: "", imageName: "", type: .empty)
    
    var availableTime: Int = 30
    var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Estado individual
    @Published private(set) var player = PlayerModel()
    
    // MARK: - Array global de players
    @Published var players: [MCPeerID: PlayerModel] = [:]

    func assignRole(_ role: PlayerRole) {
        player.role = role
    }
    
    func turnEmptyCard() {
        player.usedCard = emptyCard
    }
    
    func assignCard(card: Card) {
        player.usedCard = card
    }
    
    func receiveInitialCards() {
        player.hand.removeAll()
        switch player.role {
        case .cultist:
            player.hand.append(contentsOf: deck.commonCards.shuffled().prefix(2))
            player.hand.append(deck.specialCards.randomElement()!)
        case .heretic:
            player.hand.append(contentsOf: deck.commonCards.shuffled().prefix(2))
            player.hand.append(contentsOf: deck.heresyCards.shuffled().prefix(2))
            player.hand.append(deck.assassinationCard)
        default: break
        }
    }
    
    func removeCardFromHand(card: Card) {
        player.hand.removeAll { $0.id == card.id }
    }
    
    func removeAllCardFromHand(card: Card) {
        player.hand.removeAll()
    }
    
    func turnEnteredCardPlayOnce() {
        player.hasEnteredCardPlayOnce = true
    }
    
    func addCard(pool: [Card], needed: Int) {
        player.hand.append(contentsOf: pool.prefix(needed))
    }
    
    // MARK: - Estado global
    var globalState: GlobalGameState {
        get { multiplayerManager.globalState }
        set { multiplayerManager.globalState = newValue }
    }

    var isHost: Bool { multiplayerManager.isHosting }
    var peerID: MCPeerID { multiplayerManager.myPeerID }

    // MARK: - Computed: Pontos
    var points: Int {
        get {
            switch player.role {
            case .cultist: return globalState.sharedFaithPoints
            case .heretic: return globalState.heresyPoints[peerID.displayName, default: 0]
            default: return 0
            }
        }
        set {
            switch player.role {
            case .cultist:
                globalState.sharedFaithPoints = newValue
            case .heretic:
                globalState.heresyPoints[peerID.displayName] = newValue
            default: break
            }
        }
    }

    var followers: Int {
        get { globalState.followers }
        set { globalState.followers = newValue }
    }

    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleAssignment(_:)), name: .didReceiveRole, object: nil)
    }
    
}
