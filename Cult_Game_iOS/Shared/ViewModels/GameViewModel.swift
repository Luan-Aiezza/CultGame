import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

class GameViewModel: ObservableObject, Observable {
    //ferramentas: singleton
    @Published var timerManager = GameTimerManager()
    
    // MARK: - Estado geral do jogo
    @Published var activeCards: [SpecificCard] = []
    @Published var eliminatedPlayer: String?
    @Published var isTie: Bool = false
    @Published var didEvaluate: Bool = false
    @Published var voteOccurred: Bool = false
    @Published var deckManager = CardDistributionManager.shared
    @Published var currentPhase: GamePhase = .pairing {
        didSet {
            if multiplayerManager.isHosting {
                handlePhaseChange()
            }
        }
    }
    
    var deck = CardDeck()
    let multiplayerManager = MultiplayerManager.shared
    public var emptyCard = Card(name: "", faithCost: 0, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "", imageName: "", type: .empty, rarity: 0)
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Estado individual
    @Published private(set) var player = PlayerModel()
    @Published var gameOutcome: GameOutcome?
    
    func assignRole(_ role: PlayerRole) {
        player.role = role
    }
    
    func addCard(pool: [Card], needed: Int) {
        player.hand.append(contentsOf: pool.prefix(needed))
        print("adicionou novas cartas sim")
    }
    
    func assignCard(card: Card) {
        print("assinando uma carta nova \(card.name)")
        player.usedCard = card
    }
    
    func destroyUsedCard() {
        player.usedCard = nil
    }
    
    func attPlayer(newPlayer: PlayerModel) {
        player = newPlayer
    }
    
    func turnEmptyCard() {
        player.usedCard = emptyCard
    }
    func setRole(role: PlayerRole) {
        player.role = role
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
        print("removendo card da mao!!! \(card.name)")
    }
    
    func removeAllCardFromHand(card: Card) {
        player.hand.removeAll()
    }
    
    func turnEnteredCardPlayOnce() {
        player.hasEnteredCardPlayOnce = true
    }
    func clearEliminationResults() {
            eliminatedPlayer = nil
            isTie = false
            voteOccurred = false
            didEvaluate = false
            multiplayerManager.voted = nil
        }
    func resetGame() {
        gameOutcome = nil
        currentPhase = .pairing
        player = PlayerModel()
        activeCards.removeAll()
        deckManager = CardDistributionManager.shared
        multiplayerManager.players.removeAll()
        multiplayerManager.globalState = GlobalGameState(
            sharedFaithPoints: GameRules.initialFaithPoints,
            heresyPoints: GameRules.initialHeresy,
            followers: GameRules.initialFollowers
        )
    }

    
    // MARK: - Estado global
    var globalState: GlobalGameState {
        get { multiplayerManager.globalState }
        set { multiplayerManager.globalState = newValue }
    }
    
    var isHost: Bool { multiplayerManager.isHosting }
    var peerID: String { multiplayerManager.myPeerID.displayName }

    func endGame(with outcome: GameOutcome) {
        print("🏁 Fim de jogo — resultado: \(outcome)")
    }
    
    func createEliminatedPlayer(player: String) {
        eliminatedPlayer = player
    }
    
    func isEvaluated() {
        didEvaluate = true
    }

    
    func assignCharacter(_ character: Character) {
        player.character = character
    }
    
    @objc func handleSetInactive() {
        DispatchQueue.main.async {
            self.setState(state: .inactive)
        }
    }
    
    // MARK: - Pontos (fé/heresia)
    var points: Int {
        get {
            switch player.role {
            case .cultist:
                return globalState.sharedFaithPoints
            case .heretic:
                return globalState.heresyPoints
            default:
                return 0
            }
        }
        set {
            switch player.role {
            case .cultist:
                globalState.sharedFaithPoints = newValue
            case .heretic:
                globalState.heresyPoints = newValue
            default: break
            }
        }
    }
    
    deinit {
        print("GameViewModel está sendo desalocado")
//        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Init
    init() {
        timerManager.onEnded = { [weak self] in
            self?.advancePhaseAfterTimer()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCharacterAssignment(_:)), name: .didReceiveCharacter, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleAssignment(_:)), name: .didReceiveRole, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVictory(_:)), name: .didReceiveVictory, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSetInactive), name: .didReceiveSetInactive, object: nil)
    }
}
