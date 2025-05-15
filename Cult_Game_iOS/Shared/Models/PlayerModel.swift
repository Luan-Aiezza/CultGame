enum PlayerState {
    case active
    case inactive
}

struct PlayerModel {
    var hand: [Card] = []
    var usedCard: Card? = nil
    var role: PlayerRole? = nil
    var personalHeresyPoints: Int = 0
    var hasEnteredCardPlayOnce = false
    var state: PlayerState = .active
    var character: Character = .fox
}
