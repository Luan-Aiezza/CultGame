import SwiftUI

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
    
    func selectRole(_ selectedRole: PlayerRole) {
        self.role = selectedRole
        receiveInitialCards()
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
        card.play(vm: self)
        replenishCard()
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
}
