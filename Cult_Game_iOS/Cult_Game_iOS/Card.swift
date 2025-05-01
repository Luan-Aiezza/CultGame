import SwiftUI


enum PlayerRole {
    case cultist
    case heretic
}

struct Card: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let faithCost: Int
    let followersEffect: Int // Pode ser positivo (cultistas) ou negativo (herege)
    let description: String
    let imageName: String
    let type: CardType
    
    enum CardType {
        case common
        case cultist
        case heresy
        case assassination
    }
}

let commonCards: [Card] = [
    Card(name: "Orar", faithCost: 2, followersEffect: 5, description: "Aumenta o fervor.", imageName: "orar", type: .common),
    Card(name: "Cantar Hinos", faithCost: 1, followersEffect: 3, description: "Atrai curiosos.", imageName: "hinos", type: .common)
]

let cultistCards: [Card] = [
    Card(name: "Ritual Secreto", faithCost: 4, followersEffect: 10, description: "Laços da seita.", imageName: "ritual", type: .cultist)
]

let heresyCards: [Card] = [
    Card(name: "Espalhar Dúvidas", faithCost: 2, followersEffect: -5, description: "Abala a fé dos seguidores.", imageName: "duvida", type: .heresy),
    Card(name: "Sabotar Ritual", faithCost: 3, followersEffect: -8, description: "Enfraquece os cultistas.", imageName: "sabotar", type: .heresy)
]

let assassinationCard = Card(name: "Assassinato", faithCost: 5, followersEffect: 0, description: "Elimina um jogador.", imageName: "assassinato", type: .assassination)
