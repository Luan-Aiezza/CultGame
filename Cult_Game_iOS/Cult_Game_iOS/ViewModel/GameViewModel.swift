import SwiftUI

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
//    @Published var faithPoints: Int = 10
//    @Published var followers: Int = 0
//    @Published var usedCard: Card?

    func receiveInitialCards() {
        var hand: [Card] = []
        hand.append(contentsOf: commonCards.shuffled().prefix(2))
        hand.append(cultistCards.randomElement()!)
        playerHand = hand.shuffled()
    }

//    func playCard(_ card: Card) {
//        guard faithPoints >= card.faithCost else { return }
//        faithPoints -= card.faithCost
//        followers += card.followersGained
//        usedCard = card
//        playerHand.removeAll { $0.id == card.id }
//    }

//    func replenishCard() {
//        if let used = usedCard {
//            playerHand.append(used)
//            usedCard = nil
//        }
//    }
}
