enum PlayerState {
    case active
    case inactive
}

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
    
    var hand: [Card] = []
    var usedCard: Card? = nil
    var role: PlayerRole? = nil
    var personalHeresyPoints: Int = 0
    var hasEnteredCardPlayOnce = false
    var state: PlayerState = .active
    var votes: Int = 0
    var character: Character = .fox
}
