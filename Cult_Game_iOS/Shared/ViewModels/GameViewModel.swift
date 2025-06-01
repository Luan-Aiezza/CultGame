import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

class GameViewModel: ObservableObject, Observable {
    // MARK: - Estado geral do jogo
    @Published var currentPhase: GamePhase = .pairing {
        didSet {
            if multiplayerManager.isHosting {
                handlePhaseChange()
            }
        }
    }
    
    @Published var timeRemaining: Int = 30
    @Published var round: Int = 0
    @Published var activeCards: [SpecificCard] = []
    @Published var eliminatedPlayer: String?
    @Published var isTie: Bool = false
    @Published var didEvaluate: Bool = false
    @Published var voteOccurred: Bool = false/////////////////////
    
    @Published var deckManager = CardDistributionManager.shared
    var deck = CardDeck()
    let multiplayerManager = MultiplayerManager.shared
    public var emptyCard = Card(name: "", faithCost: 0, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "", imageName: "", type: .empty, rarity: 0)
    
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
    func setRole(_ role: PlayerRole) {
        player.role = role

       }/////////
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
            heresyPoints: 0,
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
    //var peerID: MCPeerID { multiplayerManager.peerID }
    
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

        var outcome: GameOutcome?

        if followers >= GameRules.maxFollowers {
            outcome = .cultistVictoryFollowers
        } else if activeHeretics.isEmpty {
            outcome = .cultistVictoryElimination
        } else if followers <= 0 {
            outcome = .hereticVictoryFollowers
        } else if activeHeretics.count >= cultists.count {
            outcome = .hereticVictoryBalance
        }

        if let outcome {
            print("🏁 Vitória detectada: \(outcome)")
            multiplayerManager.sendVictory(outcome)       // informa todos os peers
            self.gameOutcome = outcome                    // salva no local para navegação no iOS
            multiplayerManager.currentPhase = .victory(outcome)         // ativa a navegação condicional
        } else {
            // segue o jogo
            print("🔄 Nenhuma vitória detectada")
            advancePhaseAfterTimer()
        }
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
    
    var followers: Int {
        get { globalState.followers }
        set { globalState.followers = newValue }
    }
    
    // MARK: - Init
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCharacterAssignment(_:)), name: .didReceiveCharacter, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleAssignment(_:)), name: .didReceiveRole, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleVictory(_:)), name: .didReceiveVictory, object: nil)//////////////////
    }
}
