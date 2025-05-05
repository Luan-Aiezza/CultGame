import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var points: Int = 10
    @Published var followers: Int = 50
    @Published var role: PlayerRole? = nil
    @Published var timeRemaining: Int = 30
    
    private var availableTime: Int = 30
    private var timer: Timer?
    private var timeSubscription: Cancellable?
    
    func selectRole(_ selectedRole: PlayerRole) {
        self.role = selectedRole
        receiveInitialCards()
        startTimer()
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
            playerHand.append(assassinationCard) // carta permanente
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
            // diminuir o tempo
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // o tempo acabou
                timer?.invalidate()
                // implementar a lógica de quando o tempo acabar, como desabilitar ações do jogador
                print("Tempo acabou! Você não pode jogar mais cartas.")
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
    }

    func replenishCard() {
        if let card = usedCard {
            playerHand.append(card)
            usedCard = nil
        }
    }
}
