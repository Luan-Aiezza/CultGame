import SwiftUI
import Combine

enum GamePhase {
    case roleSelection
    case cardPlay
    case discussion
    //controla as fases do jogo
}

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var points: Int = 10
    @Published var followers: Int = 50
    @Published var role: PlayerRole? = nil
    @Published var timeRemaining: Int = 30
    @Published var currentPhase: GamePhase = .roleSelection {
        didSet {
            startTimer()
        }
    }

    private var availableTime: Int = 30
    private var timer: Timer?
    private var timeSubscription: Cancellable?
    
    
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
    func startTimer() {
            // reiniciar o cronometro
            timeRemaining = availableTime
            // cancelar o tempo
            timer?.invalidate()
            // começa o tempo novamente
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
                print("Tempo acabou na fase de jogo. Jogador não pode mais jogar cartas.")
            case .discussion:
                print("Tempo da discussão finalizado. Prosseguir com a rodada.")
                currentPhase = .roleSelection //(ou próxima fase)
            default:
                break
            }
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
        // vai precisar ser adaptado pra quando for os jogadores de fato 
        if usedCard != nil {
            currentPhase = .discussion
        }
    }

}
