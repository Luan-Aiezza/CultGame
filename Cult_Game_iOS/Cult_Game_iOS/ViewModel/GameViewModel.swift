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

    @Published var round : Int = 0
    
    //cartas ativas
    @Published var activeCards : [SpecificCard] = []
    
    //card deck
    var deck = CardDeck()
    
    //phase
    @Published var currentPhase: GamePhase = .roleSelection

    //timer
    @Published var timeRemaining: Int = 30
    private var availableTime: Int = 30
    private var timer: Timer?
    private var timeSubscription: Cancellable?

    
    
    func selectRole(_ selectedRole: PlayerRole) {
        self.role = selectedRole
        receiveInitialCards()
        currentPhase = .cardPlay
        startTimer()
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
        card.play(vm: self)
        replenishCard()
        proceedToDiscussionIfReady()
    }

    func replenishCard() {
//        if let card = usedCard {
//            playerHand.append(card)
//            usedCard = nil
//        }
        
        if playerHand.count < 3 {
            playerHand.append(deck.specialCards.randomElement()!)
        }
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
        // vai precisar ser adaptado pra quando for os jogadores de fato 
        if usedCard != nil {
            currentPhase = .discussion
        }
    }

}
