import Foundation
import SwiftUI

#warning("Uma Model sendo ObservableObject? É um modelo com comportamento? Sugestão: separar Card como modelo puro, e criar um serviço ou ViewModel que execute o método.")

class SpecificCard : Card, ObservableObject {
    @Published var isActive : Bool = false
    var specialAbility : ((GameViewModel) -> Void)?
    @Published var rotationCount : Int = 0
    
    init(name: String,
         faithCost: Int,
         followersEffect: Int,
         heresyCost: Int,
         effectsDescription: String,
         description: String,
         imageName: String,
         type: CardType,
         rarity: Int,
         isActive: Bool,
         specialAbility : ((GameViewModel) -> Void)? = nil)
    {
        super.init(name: name,
                   faithCost: faithCost,
                   heresyCost : heresyCost,
                   followersEffect: followersEffect,
                   effectsDescription: effectsDescription,
                   description: description,
                   imageName: imageName,
                   type: type,
                   rarity: rarity
        )
        
        self.specialAbility = specialAbility
        self.isActive = isActive
        self.rotationCount = 0
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func play(vm: GameViewModel) {
        vm.removeCardFromHand(card: self)
        specialAbility?(vm)
    }
}

//MARK: Sugestão

//class SpecificCardViewModel: ObservableObject {
//    @Published var isActive: Bool = false
//    @Published var rotationCount: Int = 0
//
//    let card: SpecificCard
//
//    init(card: SpecificCard) {
//        self.card = card
//    }
//
//    func playCard(in viewModel: GameViewModel) {
//        viewModel.removeCardFromHand(card: card)
//        card.specialAbility?(viewModel)
//    }
//}

