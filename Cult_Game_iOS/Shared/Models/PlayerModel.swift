
import Foundation

enum PlayerState: String, Codable {
    case active
    case inactive
}

enum PlayerRole: String, Codable {
    case cultist
    case heretic
}

enum Character : String, Codable {
    case fox
    case panda
    case bunny
    case tiger
    case deer
    case pig
    case wolf
}

struct PlayerModel: Codable, Identifiable {
    var id: String = UUID().uuidString
    
    var hand: [Card] = [
        Card(name: "Pray", faithCost: 10, heresyCost: 0, followersEffect: 5, description: "Increases fervor.", imageName: "orar", type: .common, rarity: 1),
        Card(name: "Sing Hymns", faithCost: 1, heresyCost: 0, followersEffect: 3, description: "Attracts the curious.", imageName: "hinos", type: .common, rarity: 5),
        Card(name: "Meditate", faithCost: 1, heresyCost: 0, followersEffect: 2, description: "Improves spiritual clarity.", imageName: "meditar", type: .common, rarity: 3)
    ]
    var usedCard: Card? = nil
    var role: PlayerRole? = .cultist
    var personalHeresyPoints: Int = 0
    var hasEnteredCardPlayOnce = false
    var state: PlayerState = .active
    var votes: Int = 0
    var character: Character = .fox
}
