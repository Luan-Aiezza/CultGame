//
//  CardDeck.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 15/05/25.
//

import Foundation

public class CardDeck {
    
    let commonCards: [Card] = [
        Card(name: "Pray", faithCost: 2, heresyCost: 0, followersEffect: 5, description: "Increases fervor.", imageName: "orar", type: .common, rarity: 1),
        Card(name: "Sing Hymns", faithCost: 1, heresyCost: 0, followersEffect: 3, description: "Attracts the curious.", imageName: "hinos", type: .common, rarity: 5)
    ]

    var cultistCards: [Card] = [
        Card(name: "Secret Ritual", faithCost: 4, heresyCost: 0, followersEffect: 10, description: "Strengthens cult ties.", imageName: "ritual", type: .cultist, rarity: 10)
    ]

    let heresyCards: [Card] = [
        Card(name: "Spread Doubts", faithCost: 2, heresyCost: 0, followersEffect: -5, description: "Shakes the followers' faith.", imageName: "duvida", type: .heresy, rarity: 2),
        Card(name: "Sabotage Ritual", faithCost: 3, heresyCost: 0, followersEffect: -8, description: "Weakens the cultists.", imageName: "sabotar", type: .heresy, rarity: 5)
    ]

    let assassinationCard = Card(name: "Assassination", faithCost: 5, heresyCost: 0, followersEffect: 0, description: "Eliminates a player.", imageName: "assassinato", type: .assassination, rarity: 10)
    
    var specialCards: [SpecificCard] = []

    init() {
        setupCards()
    }

    func setupCards() {
        let churchRitual = SpecificCard(
            name: "Church Ritual",
            faithCost: 2,
            followersEffect: 5,
            heresyCost: 0,
            description: "Continues to add 5 followers every turn",
            imageName: "orar",
            type: .common,
            rarity: 1,
            isActive: true
        )

        churchRitual.specialAbility = { [weak churchRitual] vm in
            guard let card = churchRitual else { return }
            print("esta fazendo a acao")
            card.rotationCount += 1
            card.isActive = true
            if !vm.activeCards.contains(where: { $0.id == card.id }) {
                vm.activeCards.append(card)
                vm.activeCards = vm.activeCards
                print(vm.activeCards)
            }

            if card.isActive == true {
                vm.followers += card.followersEffect
                //card.isActive = false
            }
        }

    
        let burstOfFaith = SpecificCard(
            name: "Burst of Faith",
            faithCost: 3,
            followersEffect: 15,
            heresyCost: 0,
            description: "Adds 15 followers after 4 rounds",
            imageName: "fe",
            type: .common,
            rarity: 1,
            isActive: true
        )

        burstOfFaith.specialAbility = { [weak burstOfFaith] vm in
            guard let card = burstOfFaith else { return }
            //ativa card e aumenta turno
            card.isActive = true
            card.rotationCount += 1
            
            //verifica se ja nao tem um card desse nos ativos
            if !vm.activeCards.contains(where: { $0.id == card.id }) {
                vm.activeCards.append(card)
                vm.activeCards = vm.activeCards
                print(vm.activeCards)
            }
            
            //acao : após 4 turnos recebe 15 de followers
            if card.rotationCount <= 4 {
                print("wait a little")
            } else {
                vm.followers += card.followersEffect
                
                //vai pra false
                card.isActive = false
            }
        }

        cultistCards.append(churchRitual)
        cultistCards.append(burstOfFaith)
    }
}
