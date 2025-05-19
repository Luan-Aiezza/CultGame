//
//  PlayerModel.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

import Foundation

enum PlayerState: String, Codable {
    case active
    case inactive
}

enum PlayerRole: String, Codable {
    case cultist
    case heretic
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
}
