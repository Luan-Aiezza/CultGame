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
         description: String,
         imageName: String,
         type: Card.CardType,
         isActive: Bool,
         specialAbility : ((GameViewModel) -> Void)? = nil)
    {
        super.init(name: name,
                   faithCost: faithCost,
                   followersEffect: followersEffect,
                   description: description,
                   imageName: imageName,
                   type: type)
        
        self.specialAbility = specialAbility
        self.isActive = isActive
        self.rotationCount = 0
    }
    
    override func play(vm: GameViewModel) {
        vm.playerHand.removeAll { $0.id == self.id }

        specialAbility?(vm)
    }
}
