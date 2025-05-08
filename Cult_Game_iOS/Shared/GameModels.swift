// GameModels.swift
import Foundation
import SwiftUI

struct CardPlayAction: Codable {
    var playerID: String
    var card: Card
    var playerRole: PlayerRole
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
}

enum PlayerRole: String, Codable {
    case cultist
    case heretic
}

enum MultiplayerMessage: Codable {
    case roleAssignment(PlayerRole)
    case kickPlayer
    
    enum CodingKeys: String, CodingKey {
        case type, data
    }
    
    enum MessageType: String, Codable {
        case roleAssignment
        case kickPlayer
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
        }
    }
}



//ESTRUTURA DAS CARTAS
struct Card: Identifiable, Codable {
    let id: UUID
    let name: String
    let faithCost: Int
    let followersEffect: Int
    let description: String
    let imageName: String
    let type: CardType
    
    init(id: UUID = UUID(), name: String, faithCost: Int, followersEffect: Int, description: String, imageName: String, type: CardType) {
        self.id = id
        self.name = name
        self.faithCost = faithCost
        self.followersEffect = followersEffect
        self.description = description
        self.imageName = imageName
        self.type = type
    }
}

//INSTANCIA DE CARTAS MANUAIS (PROVISORIO)
let commonCards: [Card] = [
    Card(name: "Pray", faithCost: 2, followersEffect: 5, description: "Increases fervor.", imageName: "orar", type: .common),
    Card(name: "Sing Hymns", faithCost: 1, followersEffect: 3, description: "Attracts the curious.", imageName: "hinos", type: .common)
]

let cultistCards: [Card] = [
    Card(name: "Secret Ritual", faithCost: 4, followersEffect: 10, description: "Strengthens cult ties.", imageName: "ritual", type: .cultist)
]

let heresyCards: [Card] = [
    Card(name: "Spread Doubts", faithCost: 2, followersEffect: -5, description: "Shakes the followers' faith.", imageName: "duvida", type: .heresy),
    Card(name: "Sabotage Ritual", faithCost: 3, followersEffect: -8, description: "Weakens the cultists.", imageName: "sabotar", type: .heresy)
]

let assassinationCard = Card(name: "Assassination", faithCost: 5, followersEffect: 0, description: "Eliminates a player.", imageName: "assassinato", type: .assassination)
