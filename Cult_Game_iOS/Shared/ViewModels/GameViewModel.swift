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
    @State var eliminatedPlayer: MCPeerID?
    @State var isTie: Bool = false
    @State var didEvaluate: Bool = false
    @Published var gameEnded: Bool = false
    @Published var gameOutcome: GameOutcome? = nil

    
    var deck = CardDeck()
    let multiplayerManager = MultiplayerManager.shared
    var emptyCard = Card(name: "", faithCost: 0, followersEffect: 0, description: "", imageName: "", type: .empty)
    
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
    
    func addCard(pool: [Card], needed: Int) {
        player.hand.append(contentsOf: pool.prefix(needed))
    }
    
    func assignCard(card: Card) {
        player.usedCard = card
    }
    
    func attPlayer(newPlayer: PlayerModel) {
        player = newPlayer
    }
    
    func turnEmptyCard() {
        player.usedCard = emptyCard
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
    
    // MARK: - Estado global
    var globalState: GlobalGameState {
        get { multiplayerManager.globalState }
        set { multiplayerManager.globalState = newValue }
    }
    
    var isHost: Bool { multiplayerManager.isHosting }
    var peerID: MCPeerID { multiplayerManager.myPeerID }
    
    // Personagens sorteados (por peer)
    @Published var assignedCharacters: [MCPeerID: Character] = [:]
    
    // MARK: - Encerramento do jogo
    func endGame(with outcome: GameOutcome) {
        gameEnded = true
        gameOutcome = outcome
        print("🏁 Fim de jogo — resultado: \(outcome)")
    }
    func resetGame() {
        globalState = GlobalGameState(
            sharedFaithPoints: GameRules.initialFaithPoints,
            heresyPoints: [:],
            followers: GameRules.initialFollowers
        )
        currentPhase = .roleSelection
        player = PlayerModel()
        gameEnded = false
        gameOutcome = nil
    }

    
    // MARK: - Recebe personagem sorteado
    @objc func handleCharacterAssignment(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let peerID = userInfo["peerID"] as? MCPeerID,
            let character = userInfo["character"] as? Character
        else { return }
        
        DispatchQueue.main.async {
            self.assignedCharacters[peerID] = character
            if peerID == self.peerID {
                self.player.character = character
            }
        }
    }
    
    // MARK: - Verificação de vitória
    func checkVictoryConditions() {
        print("⚖️ Verificando condições de vitória...")
        
        let cultists = multiplayerManager.connectedPeers.filter {
            multiplayerManager.getRoles(for: [$0])[$0] == .cultist
        }
        
        let heretics = multiplayerManager.connectedPeers.filter {
            multiplayerManager.getRoles(for: [$0])[$0] == .heretic
        }
        
        let activeHeretics = heretics.filter {
            multiplayerManager.getPlayerStates(for: [$0])[$0]?.state == .active
        }
        
        if followers <= 0 {
            print("🏴 Vitória dos Hereges: seguidores chegaram a 0")
            endGame(with: .hereticVictory)
            return
        }
        
        if followers >= GameRules.maxFollowers {
            print("✝️ Vitória dos Cultistas: seguidores chegaram ao máximo")
            endGame(with: .cultistVictory)
            return
        }
    }
    
    // Observa pedidos de verificação de vitória enviados via NotificationCenter
    @objc func triggerVictoryCheck() {
        checkVictoryConditions()
    }
    
    func assignCharacter(_ character: Character) {
        player.character = character
    }
    
    // MARK: - Computed: Pontos
    var points: Int {
        get {
            switch player.role {
            case .cultist:
                return globalState.sharedFaithPoints
            case .heretic:
                return globalState.heresyPoints[peerID.displayName, default: 0]
            default:
                return 0
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleCharacterAssignment(_:)), name: .didReceiveCharacter, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(triggerVictoryCheck), name: .shouldCheckVictoryConditions, object: nil)
    }
}
