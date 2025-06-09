import SwiftUI
import Foundation
import GameKit
import Combine

class GameViewModel: ObservableObject {
    
    // MARK: - Estados
    @Published var activeCards: [SpecificCard] = []
    @Published var eliminatedPlayer: String?
    @Published var isTie: Bool = false
    @Published var didEvaluate: Bool = false
    @Published var voteOccurred: Bool = false
    @Published var deckManager = CardDistributionManager.shared
    @Published var currentPhase: GamePhase = .pairing {
        didSet {
            if multiplayer.isHosting {
                multiplayer.sendGamePhase(currentPhase)
            }
        }
    }
    
    @Published private(set) var player = PlayerModel()
    @Published var gameOutcome: GameOutcome?
    
    var deck = CardDeck()
    let multiplayer = GameKitMultiplayerManager.shared
    public let emptyCard = Card(name: "", faithCost: 0, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "", imageName: "", type: .empty, rarity: 0)
    
    var isHost: Bool { multiplayer.isHosting }
    var peerID: String { multiplayer.localPlayer.playerID }

    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleAssignment(_:)), name: .didReceiveRole, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVictory(_:)), name: .didReceiveVictory, object: nil)
    }

    // MARK: - Funções principais
    func assignRole(_ role: PlayerRole) {
        player.role = role
    }

    func assignCharacter(_ character: Character) {
        player.character = character
    }

    func addCard(pool: [Card], needed: Int) {
        player.hand.append(contentsOf: pool.prefix(needed))
    }

    func assignCard(card: Card) {
        player.usedCard = card
    }

    func turnEmptyCard() {
        player.usedCard = emptyCard
    }
    
    func turnEnteredCardPlayOnce() {
        player.hasEnteredCardPlayOnce = true
    }

    func setState(state: PlayerState) {
        player.state = state
    }

    func receiveInitialCards() {
        player.hand.removeAll()
        switch player.role {
        case .cultist:
            player.hand.append(contentsOf: deck.commonCards.shuffled().prefix(2))
            player.hand.append(deck.cultistCards.randomElement()!)
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

    func resetGame() {
        gameOutcome = nil
        currentPhase = .pairing
        player = PlayerModel()
        activeCards.removeAll()
        deckManager = CardDistributionManager.shared
        multiplayer.players.removeAll()
        multiplayer.globalState = GlobalGameState(
            sharedFaithPoints: GameRules.initialFaithPoints,
            heresyPoints: GameRules.initialHeresy,
            followers: GameRules.initialFollowers
        )
    }

    var globalState: GlobalGameState {
        get { multiplayer.globalState }
        set { multiplayer.globalState = newValue }
    }

    var points: Int {
        get {
            switch player.role {
            case .cultist: return globalState.sharedFaithPoints
            case .heretic: return globalState.heresyPoints
            default: return 0
            }
        }
        set {
            switch player.role {
            case .cultist: globalState.sharedFaithPoints = newValue
            case .heretic: globalState.heresyPoints = newValue
            default: break
            }
        }
    }
}

import Foundation

extension Notification.Name {
    static let didReceiveGameData = Notification.Name("didReceiveGameData")
    static let didReceiveRole = Notification.Name("didReceiveRole")
    static let didReceiveVictory = Notification.Name("didReceiveVictory")
}
