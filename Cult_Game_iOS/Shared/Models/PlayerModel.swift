//
//  PlayerModel.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

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
