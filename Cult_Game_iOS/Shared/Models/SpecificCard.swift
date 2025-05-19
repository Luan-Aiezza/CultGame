//
//  SpecificCard.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 05/05/25.
//

import Foundation
import SwiftUI

class SpecificCard : Card, ObservableObject{
    @Published var isActive : Bool = false
    var specialAbility : ((GameViewModel) -> Void)?
    @Published var rotationCount : Int = 0
    
    init(name: String,
         faithCost: Int,
         followersEffect: Int,
         heresyCost: Int,
         description: String,
         imageName: String,
         type: Card.CardType,
         rarity: Int,
         isActive: Bool,
         specialAbility : ((GameViewModel) -> Void)? = nil)
    {
        super.init(name: name,
                   faithCost: faithCost,
                   heresyCost : heresyCost,
                   followersEffect: followersEffect,
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
