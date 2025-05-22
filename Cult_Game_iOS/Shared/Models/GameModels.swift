// GameModels.swift
import Foundation
import SwiftUI

struct CardPlayAction: Codable {
    var playerID: String
    var card: Card
    var playerRole: PlayerRole
}

enum GamePhase: String, Codable {
    case pairing
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

enum GameOutcome {
    case cultistVictory
    case hereticVictory
}

struct GameRules {
    static let maxFollowers = 40
    static let initialFollowers = 35
    static let maxFaithPoints = 80
    static let initialFaithPoints = 45
    
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
    case attPhase(GamePhase)
    
    case roleAssignment(PlayerRole)
    case kickPlayer
    case characterAssignment(Character)
    case vote(String)
    case setInactive(String)
    case updatePlayers([String: PlayerModel])
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    enum MessageType: String, Codable {
        case attPhase
        case roleAssignment
        case kickPlayer
        case characterAssignment
        case vote
        case setInactive
        case updatePlayers
    }
    
    // Manual Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .attPhase(let phase):
            try container.encode(MessageType.attPhase, forKey: .type)
                    try container.encode(phase, forKey: .data)

        case .roleAssignment(let role):
            try container.encode(MessageType.roleAssignment, forKey: .type)
            try container.encode(role, forKey: .data)
            
        case .kickPlayer:
            try container.encode(MessageType.kickPlayer, forKey: .type)
            //decodificar a mensagem do personagem
        case .characterAssignment(let character):
            try container.encode(MessageType.characterAssignment, forKey: .type)
            try container.encode(character, forKey: .data)
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
        case .attPhase:
                let phase = try container.decode(GamePhase.self, forKey: .data)
                self = .attPhase(phase)
        case .roleAssignment:
            let role = try container.decode(PlayerRole.self, forKey: .data)
            self = .roleAssignment(role)
            
        case .kickPlayer:
            self = .kickPlayer
            //decodificar a mensagem do personagem
        case .characterAssignment:
            let character = try container.decode(Character.self, forKey: .data)
            self = .characterAssignment(character)
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
