import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

enum GamePhase {
    case roleSelection
    case cardPlay
    case discussion
}

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var role: PlayerRole? = nil
    @Published var round : Int = 0
    private var cancellables = Set<AnyCancellable>()
    private let multiplayerManager = MultiplayerManager.shared
    private var peerID: MCPeerID {
        multiplayerManager.myPeerID
    }

    var isHost: Bool {
        multiplayerManager.isHosting
    }

    var points: Int {
        get {
            guard let role else { return 0 }
            if role == .cultist {
                return multiplayerManager.globalState.sharedFaithPoints
            } else {
                return multiplayerManager.globalState.heresyPoints[peerID.displayName, default: 0]
            }
        }
        set {
            guard let role else { return }
            if role == .cultist {
                multiplayerManager.globalState.sharedFaithPoints = newValue
            } else {
                multiplayerManager.globalState.heresyPoints[peerID.displayName] = newValue
            }
        }
    }

    
    var followers: Int {
        get {
            multiplayerManager.globalState.followers
        }
        set {
            multiplayerManager.globalState.followers = newValue
        }
    }
    
    var heresyPoints: [String: Int] {
        get {
            multiplayerManager.globalState.heresyPoints
        }
        set {
            multiplayerManager.globalState.heresyPoints = newValue
        }
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRoleAssignment(_:)), name: .didReceiveRole, object: nil)

    }
    
    //cartas ativas
    @Published var activeCards : [SpecificCard] = []
    
    //card deck
    var deck = CardDeck()

    //timer
    @Published var timeRemaining: Int = 30
    @Published var currentPhase: GamePhase = .roleSelection {
        didSet {
            startTimer()
            handlePhaseChange()
        }
    }

    private var availableTime: Int = 30
    private var timer: Timer?
    private var timeSubscription: Cancellable?
    private var alreadyEnteredCardPlayOnce = false

    // MARK: - Timer
    func startTimer() {
        timeRemaining = availableTime
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            switch currentPhase {
            case .cardPlay:
                currentPhase = .discussion
            case .discussion:
                currentPhase = .cardPlay
            default:
                break
            }
        }
    }

    @objc func syncState() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    // MARK: -  mudança de fase
    func handlePhaseChange() {
        switch currentPhase {
        case .cardPlay:
            if alreadyEnteredCardPlayOnce {
                let peerKey = peerID.displayName
                heresyPoints[peerKey] = (heresyPoints[peerKey] ?? 0) + 1
            }
            alreadyEnteredCardPlayOnce = true
            replenishHandIfNeeded()
        default:
            break
        }
    }

    func replenishHandIfNeeded() {
        let needed = 3 - playerHand.count
        guard needed > 0 else { return }

        var pool: [Card] = []

        switch role {
        case .cultist:
            pool = (deck.commonCards + deck.cultistCards).shuffled()
        case .heretic:
            pool = (deck.commonCards + deck.heresyCards + [deck.assassinationCard]).shuffled()
        default:
            break
        }

        playerHand.append(contentsOf: pool.prefix(needed))
    }

    // MARK: - Jogo
    func selectRole(_ selectedRole: PlayerRole) {
        self.role = selectedRole
        receiveInitialCards()
        currentPhase = .cardPlay
    }

    func receiveInitialCards() {
        playerHand.removeAll()
        switch role {
        case .cultist:
            playerHand.append(contentsOf: deck.commonCards.shuffled().prefix(2))
            playerHand.append(deck.specialCards.randomElement()!)
        case .heretic:
            playerHand.append(contentsOf: deck.commonCards.shuffled().prefix(2))
            playerHand.append(contentsOf: deck.heresyCards.shuffled().prefix(2))
            playerHand.append(deck.assassinationCard) // carta permanente
        default: break
        }
    }

    func playCard(_ card: Card) {
        guard points >= card.faithCost else { return }

        let action = CardPlayAction(playerID: peerID.displayName, card: card, playerRole: role!)

        if isHost {
            multiplayerManager.handleReceived(try! JSONEncoder().encode(action), from: peerID)
        } else {
            multiplayerManager.send(action)
        }

        if card.type != .assassination {
            usedCard = card
            playerHand.removeAll { $0.id == card.id }
        }
        
        card.play(vm: self)
        replenishCard()
        proceedToDiscussionIfReady()
        
    }

    func replenishCard() {
        if let card = usedCard {
            playerHand.append(card)
            usedCard = nil
        }
        
//        if playerHand.count < 3 {
//            playerHand.append(deck.specialCards.randomElement()!)
//        }
    }
    
    func addRound() {
        round += 1
        playAllActiveCards()
    }
    
    func playAllActiveCards() {
        
        activeCards.removeAll { ($0 as AnyObject).isActive == false }
        
        for card in activeCards {
            card.play(vm: self)
        }
    }

    func proceedToDiscussionIfReady() {
        if usedCard != nil {
            currentPhase = .discussion
        }
    }
    
    @objc private func handleRoleAssignment(_ notification: Notification) {
        if let role = notification.object as? PlayerRole {
            DispatchQueue.main.async {
                self.role = role
                self.receiveInitialCards()
                self.currentPhase = .cardPlay
            }
        }
    }
}
