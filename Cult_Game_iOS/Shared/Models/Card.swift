import SwiftUI

//ESTRUTURA DAS CARTAS
class Card: Identifiable, Equatable, Codable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id : UUID
    let name: String
    let faithCost: Int
    let heresyCost : Int
    let followersEffect: Int
    let description: String
    let imageName: String
    let type: CardType
    var rarity : Int
    
    init(name: String, faithCost: Int, heresyCost: Int, followersEffect: Int, description: String, imageName: String, type: CardType, rarity: Int) {
        self.id = UUID()
        self.name = name
        self.faithCost = faithCost
        self.heresyCost = heresyCost
        self.followersEffect = followersEffect
        self.description = description
        self.imageName = imageName
        self.type = type
        self.rarity = rarity
        
    }
    
    func play(vm : GameViewModel){
        guard vm.points >= faithCost else { return }
        vm.points -= faithCost
        vm.followers += followersEffect

        if type != .assassination {
            vm.assignCard(card: self)
            vm.removeCardFromHand(card: self)
            print("jogando carta!!! \(self.name)")
        }
    }
    
    enum CardType : String, Codable {
        case common
        case cultist
        case heresy
        case assassination
        case empty
    }
}



