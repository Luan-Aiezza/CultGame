
import Foundation

enum PlayerState: String, Codable {
    case active
    case inactive
}

enum PlayerRole: String, Codable {
    case cultist
    case heretic
}

enum Character: String, Codable, CaseIterable {
    case fox, panda, bunny, tiger, deer, pig, wolf
}

struct PlayerModel: Codable, Identifiable, Equatable {
    var id: String = UUID().uuidString
    
    var hand: [Card] = []
    var usedCard: Card? = nil
    var role: PlayerRole? = nil
    var personalHeresyPoints: Int = 0
    var hasEnteredCardPlayOnce = false
    var state: PlayerState = .active
    var votes: Int = 0
    var character: Character? = nil
}

extension Character {
    var displayName: String {
        switch self {
        case .fox: return "fox"
        case .panda: return "panda"
        case .bunny: return "bunny"
        case .tiger: return "tiger"
        case .deer: return "deer"
        case .pig: return "pig"
        case .wolf: return "wolf"
        }
    }
}
