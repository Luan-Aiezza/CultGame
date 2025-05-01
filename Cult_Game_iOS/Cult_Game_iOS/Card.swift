import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let faithCost: Int
    let followersGained: Int
    let description: String
    let imageName: String
    let type: CardType
    
    enum CardType {
        case commonCard
        case cultistCard
    }
}

let commonCards: [Card] = [
    Card(name: "Orar", faithCost: 2, followersGained: 5, description: "Aumenta o fervor dos fiéis.", imageName: "", type: .commonCard),
    Card(name: "Cantar Hinos", faithCost: 1, followersGained: 3, description: "Atrai fiéis para perto.", imageName: "", type: .commonCard)
]

let cultistCards: [Card] = [
    Card(name: "Ritual Secreto", faithCost: 4, followersGained: 10, description: "Reforça os laços do culto.", imageName: "", type: .cultistCard)
]
