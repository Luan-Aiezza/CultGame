import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

class GameViewModel: ObservableObject, Observable {
    // MARK: - Estado geral do jogo
    @Published var currentPhase: GamePhase = .roleSelection {
        didSet {
            if multiplayerManager.isHosting {
                startTimer()
                handlePhaseChange()
                print("Startou pelo host")
            }
        }
    }
    
    @Published var timeRemaining: Int = 30
    @Published var round: Int = 0
    @Published var activeCards: [SpecificCard] = []
    @State var eliminatedPlayer: MCPeerID?
    @State var isTie: Bool = false
    @State var didEvaluate: Bool = false
    
    @Published var deckManager = CardDistributionManager.shared

    var deck = CardDeck()
    let multiplayerManager = MultiplayerManager.shared
    public var emptyCard = Card(name: "", faithCost: 0, heresyCost: 0, followersEffect: 0, description: "", imageName: "", type: .empty, rarity: 0)
    
    var availableTime: Int = 30
    var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Estado individual
    @Published private(set) var player = PlayerModel()
    
    // MARK: - Array global de players
    @Published var players: [MCPeerID: PlayerModel] = [:]
    
    @Published var gameOutcome: GameOutcome?

    @objc func handleVictory(_ notification: Notification) {
        if let outcome = notification.object as? GameOutcome {
            self.gameOutcome = outcome
            self.currentPhase = .victory(outcome)
        }//////////////////
    }

    
    func assignRole(_ role: PlayerRole) {
        player.role = role
    }
    
    func addCard(pool: [Card], needed: Int) {
        player.hand.append(contentsOf: pool.prefix(needed))
        print("adicionou novas cartas sim")
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
    
    func resetGame() {
        // Reinicializa variáveis importantes
        currentPhase = .roleSelection
        round = 0
        timeRemaining = availableTime
        player = PlayerModel()
        activeCards.removeAll()
        deckManager = CardDistributionManager.shared
        multiplayerManager.players.removeAll()
        multiplayerManager.assignedRoles.removeAll()
        multiplayerManager.playerStates.removeAll()
        multiplayerManager.globalState = GlobalGameState(
            sharedFaithPoints: GameRules.initialFaithPoints,
            heresyPoints: [:],
            followers: GameRules.initialFollowers
        )
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
    
    // Jogadores conectados + personagens (para a tela de espera)
    //    var playersForDisplay: [Player] {
    //        multiplayerManager.connectedPeers
    //            .compactMap { peer in
    //                guard let character = assignedCharacters[peer] else { return nil }
    //                return Player(
    //                    peerID: peer,
    //                    isYou: peer == multiplayerManager.myPeerID,
    //                    character: character
    //                )
    //            }
    //            .sorted { $0.isYou && !$1.isYou }
    //    }
    
    func endGame(with outcome: GameOutcome) {
        print("🏁 Fim de jogo — resultado: \(outcome)")
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
            
            //Se for o próprio jogador, atualiza também localmente
            if peerID == self.peerID {
                self.player.character = character
            }
        }
    }
    
    // MARK: - Verificação de vitória
    
    
    func evaluateVictory() {
        let cultists = multiplayerManager.connectedPeers.filter {
            multiplayerManager.getRoles(for: [$0])[$0] == .cultist &&
            multiplayerManager.getPlayerStates(for: [$0])[$0]?.state == .active
        }
        
        let heretics = multiplayerManager.connectedPeers.filter {
            multiplayerManager.getRoles(for: [$0])[$0] == .heretic
        }
        
        let activeHeretics = heretics.filter {
            multiplayerManager.getPlayerStates(for: [$0])[$0]?.state == .active
        }

        if followers >= GameRules.maxFollowers {
            multiplayerManager.sendVictory(.cultistVictoryFollowers)
        } else if activeHeretics.isEmpty {
            multiplayerManager.sendVictory(.cultistVictoryElimination)
        } else if followers <= 0 {
            multiplayerManager.sendVictory(.hereticVictoryFollowers)
        } else if activeHeretics.count >= cultists.count {
            multiplayerManager.sendVictory(.hereticVictoryBalance)
        } else {
            // Segue normalmente para próxima fase se não houver vitória
            currentPhase = .cardPlay
            multiplayerManager.sendGamePhase(.cardPlay)
        }//////////////////////////
    }

    
    func assignCharacter(_ character: Character) {
        player.character = character
    }
    
    // MARK: - Pontos (fé/heresia)
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleVictory(_:)), name: .didReceiveVictory, object: nil)//////////////////

        
    }
    
    
}
