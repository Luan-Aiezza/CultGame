import SwiftUI
import UniformTypeIdentifiers

//ESTRUTURA DAS CARTAS
class Card: Identifiable, Equatable, Codable, Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .card)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id : UUID
    let name: String
    let faithCost: Int
    let heresyCost : Int
    let followersEffect: Int
    let effectsDescription : String
    let description: String
    let imageName: String
    let type: CardType
    var rarity : Int
    
    init(name: String, faithCost: Int, heresyCost: Int, followersEffect: Int, effectsDescription: String, description: String, imageName: String, type: CardType, rarity: Int) {
        self.id = UUID()
        self.name = name
        self.faithCost = faithCost
        self.heresyCost = heresyCost
        self.followersEffect = followersEffect
        self.effectsDescription = effectsDescription
        self.description = description
        self.imageName = imageName
        self.type = type
        self.rarity = rarity
        
    }
    
    func play(vm: GameViewModel) {
        guard let role = vm.player.role else { return }
        let action = CardPlayAction(playerID: vm.peerID, card: self, playerRole: role)
        
        print("agora ta dentro daquela funcao de DENTRO da carta")
        
        vm.multiplayerManager.send(action)
    }
}
