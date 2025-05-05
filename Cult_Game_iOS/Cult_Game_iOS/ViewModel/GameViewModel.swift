import SwiftUI
import Combine

enum GamePhase {
    case roleSelection
    case cardPlay
    case discussion
}

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var points: Int = 10
    @Published var followers: Int = 50
    @Published var heresyPoints: Int = 0
    @Published var role: PlayerRole? = nil
    @Published var timeRemaining: Int = 30
    @Published var currentPhase: GamePhase = .roleSelection {
        didSet {
            startTimer()
            handlePhaseChange()
        }
    }

    private var availableTime: Int = 30
    private var timer: Timer?
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

    // MARK: -  mudança de fase
    func handlePhaseChange() {
        switch currentPhase {
        case .cardPlay:
            if alreadyEnteredCardPlayOnce {
                heresyPoints += 1 // aumenta heresia cada vez que volta pra tela de selcionar cartas
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
            pool = (commonCards + cultistCards).shuffled()
        case .heretic:
            pool = (commonCards + heresyCards + [assassinationCard]).shuffled()
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
            playerHand.append(contentsOf: commonCards.shuffled().prefix(2))
            playerHand.append(cultistCards.randomElement()!)
        case .heretic:
            playerHand.append(contentsOf: commonCards.shuffled().prefix(2))
            playerHand.append(contentsOf: heresyCards.shuffled().prefix(2))
            playerHand.append(assassinationCard)
        default: break
        }
    }

    func playCard(_ card: Card) {
        guard points >= card.faithCost else { return }
        points -= card.faithCost
        followers += card.followersEffect

        if card.type != .assassination {
            usedCard = card
            playerHand.removeAll { $0.id == card.id }
        }

        proceedToDiscussionIfReady()
    }

    func replenishCard() {
        if let card = usedCard {
            playerHand.append(card)
            usedCard = nil
        }
    }

    func proceedToDiscussionIfReady() {
        if usedCard != nil {
            currentPhase = .discussion
        }
    }
}
