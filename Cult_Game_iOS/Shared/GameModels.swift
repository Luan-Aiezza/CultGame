// GameModels.swift
import Foundation
import SwiftUI

struct CardPlayAction: Codable {
    var playerID: String
    var card: Card
    var playerRole: PlayerRole
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

struct GameUpdate: Codable {
    var sharedFaithPoints: Int
    var sharedFollowers: Int
}

// Estado global sincronizado
struct GlobalGameState: Codable {
    var sharedFaithPoints: Int
    var heresyPoints: [String: Int] // ID do herege -> pontos
    var followers: Int
}


//CONTROLE DO TIPO DE JOGADOR
enum CardType: String, Codable {
    case common
    case cultist
    case heresy
    case assassination
    case empty
}

enum MultiplayerMessage: Codable {
    case roleAssignment(PlayerRole)
    case kickPlayer
    case characterAssignment(Character)
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    enum MessageType: String, Codable {
        case roleAssignment
        case kickPlayer
        case characterAssignment
    }
    
    // Manual Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .roleAssignment(let role):
            try container.encode(MessageType.roleAssignment, forKey: .type)
            try container.encode(role, forKey: .data)
        case .kickPlayer:
            try container.encode(MessageType.kickPlayer, forKey: .type)
            // Não há data para codificar
        case .characterAssignment(let character):
            try container.encode(MessageType.characterAssignment, forKey: .type)
            try container.encode(character, forKey: .data)
            
        }
    }
    
    // Manual Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(MessageType.self, forKey: .type)
        switch type {
        case .roleAssignment:
            let role = try container.decode(PlayerRole.self, forKey: .data)
            self = .roleAssignment(role)
        case .kickPlayer:
            self = .kickPlayer
        case .characterAssignment:
            let character = try container.decode(Character.self, forKey: .data)
            self = .characterAssignment(character)
        }
        
    }
}
