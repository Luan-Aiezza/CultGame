// GameModels.swift
import Foundation
import SwiftUI

struct CardPlayAction: Codable {
    var playerID: String
    var card: Card
    var playerRole: PlayerRole
}


enum GamePhase {
    case roleSelection
    case cardPlay
    case discussion
    case elimination
    case eliminationResults
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
    case vote(String)
    case setInactive(String)
    case updatePlayers([String: PlayerModel])

    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    enum MessageType: String, Codable {
        case roleAssignment
        case kickPlayer
        case vote
        case setInactive
        case updatePlayers
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
            
        case .vote(let peerID):
            try container.encode(MessageType.vote, forKey: .type)
            try container.encode(peerID, forKey: .data)
            
        case .setInactive(let peerID):
            try container.encode(MessageType.setInactive, forKey: .type)
            try container.encode(peerID, forKey: .data)
            
        case .updatePlayers(let players):
            try container.encode(MessageType.updatePlayers, forKey: .type)
            try container.encode(players, forKey: .data)
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
            
        case .vote:
            let peerID = try container.decode(String.self, forKey: .data)
            self = .vote(peerID)
            
        case .setInactive:
            let peerID = try container.decode(String.self, forKey: .data)
            self = .setInactive(peerID)
            
        case .updatePlayers:
            let players = try container.decode([String: PlayerModel].self, forKey: .data)
            self = .updatePlayers(players)
        }
    }

}
