import SwiftUI

//CONTROLE DO TIPO DE JOGADOR
enum PlayerRole {
    case cultist
    case heretic
}

//ESTRUTURA DAS CARTAS
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

//INSTANCIA DE CARTAS MANUAIS (PROVISORIO)
let commonCards: [Card] = [
    Card(name: "Pray", faithCost: 2, followersEffect: 5, description: "Increases fervor.", imageName: "orar", type: .common),
    Card(name: "Sing Hymns", faithCost: 1, followersEffect: 3, description: "Attracts the curious.", imageName: "hinos", type: .common)
]

let cultistCards: [Card] = [
    Card(name: "Secret Ritual", faithCost: 4, followersEffect: 10, description: "Strengthens cult ties.", imageName: "ritual", type: .cultist)
]

let heresyCards: [Card] = [
    Card(name: "Spread Doubts", faithCost: 2, followersEffect: -5, description: "Shakes the followers' faith.", imageName: "duvida", type: .heresy),
    Card(name: "Sabotage Ritual", faithCost: 3, followersEffect: -8, description: "Weakens the cultists.", imageName: "sabotar", type: .heresy)
]

let assassinationCard = Card(name: "Assassination", faithCost: 5, followersEffect: 0, description: "Eliminates a player.", imageName: "assassinato", type: .assassination)
