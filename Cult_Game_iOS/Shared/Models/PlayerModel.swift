
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
    
    var hand: [Card] = [
        Card(name: "Luz Sagrada",
             faithCost: 3,
             heresyCost: 0,
             followersEffect: 5,
             effectsDescription: "Cura seus seguidores e fortalece a fé.",
             description: "Uma luz divina que protege e cura.",
             imageName: "luz_sagrada",
             type: .heresy,
             rarity: 2),
        
        Card(name: "Lâmina Sombria",
             faithCost: 0,
             heresyCost: 4,
             followersEffect: -3,
             effectsDescription: "Ataque poderoso que causa medo no inimigo.",
             description: "Uma lâmina envolta em trevas, afiada e mortal.",
             imageName: "lamina_sombria",
             type: .heresy,
             rarity: 3),
        
        Card(name: "Escudo de Fé",
             faithCost: 2,
             heresyCost: 0,
             followersEffect: 0,
             effectsDescription: "Bloqueia ataques inimigos temporariamente.",
             description: "Um escudo impenetrável protegido pela fé.",
             imageName: "escudo_fe",
             type: .heresy,
             rarity: 1),
        
        Card(name: "Magia Proibida",
             faithCost: 0,
             heresyCost: 5,
             followersEffect: -4,
             effectsDescription: "Lança um feitiço poderoso, mas perigoso.",
             description: "Uma magia que corrompe e destrói, mas tem custo alto.",
             imageName: "magia_proibida",
             type: .heresy,
             rarity: 4),
        
        Card(name: "Benção dos Fiéis",
             faithCost: 4,
             heresyCost: 0,
             followersEffect: 6,
             effectsDescription: "Aumenta o número de seguidores rapidamente.",
             description: "Uma bênção que atrai fiéis para sua causa.",
             imageName: "bencao_fieis",
             type: .heresy,
             rarity: 3)
    ]
    var usedCard: Card? = nil
    var role: PlayerRole? = nil
    var personalHeresyPoints: Int = 0
    var hasEnteredCardPlayOnce = false
    var state: PlayerState = .active
    var votes: Int = 0
    var character: Character? = nil
}
