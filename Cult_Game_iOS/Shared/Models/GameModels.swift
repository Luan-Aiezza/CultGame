// GameModels.swift
import Foundation
import SwiftUI

// MARK: - Ação de Jogada
struct CardPlayAction: Codable {
    var playerID: String
    var card: Card
    var playerRole: PlayerRole
}

// MARK: - Efeitos do jogo
struct GameEffects: Codable {
    let playerID: String
    let faithChange: Int
    let heresyChange: Int
    let followersChange: Int
}

// MARK: - Resultado final
enum GameOutcome: String, Codable {
    case cultistVictoryFollowers
    case cultistVictoryElimination
    case hereticVictoryFollowers
    case hereticVictoryBalance
}

// MARK: - Fases do jogo
enum GamePhase: Codable, Equatable {
    case pairing
    case roleSelection
    case cardPlay
    case discussion
    case elimination
    case eliminationResults
    case victory(GameOutcome)
}

// MARK: - Atualização pontual
struct GameUpdate: Codable {
    var sharedFaithPoints: Int
    var sharedFollowers: Int
}

// MARK: - Regras base
struct GameRules {
    static let maxFollowers = 40
    static let initialFollowers = 35
    static let initialHeresy = 0
    static let maxFaithPoints = 1000
    static let initialFaithPoints = 5
}

// MARK: - Estado global sincronizado
struct GlobalGameState: Codable {
    var sharedFaithPoints: Int
    var heresyPoints: Int
    var followers: Int
}

// MARK: - Tipos de carta
enum CardType: String, Codable {
    case common
    case cultist
    case heresy
    case assassination
    case empty
}

// MARK: - Mensagens trocadas via rede
enum MultiplayerMessage: Codable {
    case attPhase(GamePhase)
    case roleAssignment(PlayerRole)
    case kickPlayer
    case characterAssignment(String)      // playerID
    case vote(String)                     // playerID
    case kill(String)                     // playerID
    case setInactive(String)             // playerID
    case updatePlayers([String: PlayerModel]) // playerID -> model
    case victory(GameOutcome)
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    enum MessageType: String, Codable {
        case attPhase
        case roleAssignment
        case kickPlayer
        case characterAssignment
        case vote
        case kill
        case setInactive
        case updatePlayers
        case victory
    }

    // MARK: - Encoding manual
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
            
        case .characterAssignment(let playerID):
            try container.encode(MessageType.characterAssignment, forKey: .type)
            try container.encode(playerID, forKey: .data)
            
        case .vote(let playerID):
            try container.encode(MessageType.vote, forKey: .type)
            try container.encode(playerID, forKey: .data)
            
        case .kill(let playerID):
            try container.encode(MessageType.kill, forKey: .type)
            try container.encode(playerID, forKey: .data)
            
        case .setInactive(let playerID):
            try container.encode(MessageType.setInactive, forKey: .type)
            try container.encode(playerID, forKey: .data)
            
        case .updatePlayers(let players):
            try container.encode(MessageType.updatePlayers, forKey: .type)
            try container.encode(players, forKey: .data)
            
        case .victory(let outcome):
            try container.encode(MessageType.victory, forKey: .type)
            try container.encode(outcome, forKey: .data)
        }
    }

    // MARK: - Decoding manual
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
            
        case .characterAssignment:
            let playerID = try container.decode(String.self, forKey: .data)
            self = .characterAssignment(playerID)
            
        case .vote:
            let playerID = try container.decode(String.self, forKey: .data)
            self = .vote(playerID)
            
        case .kill:
            let playerID = try container.decode(String.self, forKey: .data)
            self = .kill(playerID)
            
        case .setInactive:
            let playerID = try container.decode(String.self, forKey: .data)
            self = .setInactive(playerID)
            
        case .updatePlayers:
            let players = try container.decode([String: PlayerModel].self, forKey: .data)
            self = .updatePlayers(players)
            
        case .victory:
            let outcome = try container.decode(GameOutcome.self, forKey: .data)
            self = .victory(outcome)
        }
    }
}
