//
//  CardDeck.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 15/05/25.
//

import Foundation

public class CardDeck {
    
    let commonCards: [Card] = [
        Card(name: "Pray", faithCost: 2, heresyCost: 0, followersEffect: 5, effectsDescription: "", description: "Increases fervor.", imageName: "orar", type: .common, rarity: 1),
        Card(name: "Sing Hymns", faithCost: 1, heresyCost: 0, followersEffect: 3, effectsDescription: "", description: "Attracts the curious.", imageName: "hinos", type: .common, rarity: 5),
        Card(name: "Meditate", faithCost: 1, heresyCost: 0, followersEffect: 2, effectsDescription: "", description: "Improves spiritual clarity.", imageName: "meditar", type: .common, rarity: 3),
        Card(name: "Give Sermon", faithCost: 3, heresyCost: 0, followersEffect: 6, effectsDescription: "", description: "Inspires the faithful.", imageName: "sermao", type: .common, rarity: 4),
        Card(name: "Hand Out Pamphlets", faithCost: 1, heresyCost: 0, followersEffect: 4, effectsDescription: "", description: "Spreads the word.", imageName: "panfleto", type: .common, rarity: 2)
    ]

    var cultistCards: [Card] = [
        Card(name: "Secret Ritual", faithCost: 4, heresyCost: 0, followersEffect: 10, effectsDescription: "", description: "Strengthens cult ties.", imageName: "ritual", type: .cultist, rarity: 10),
        Card(name: "Dark Meditation", faithCost: 2, heresyCost: 1, followersEffect: 6, effectsDescription: "", description: "Empowers inner darkness.", imageName: "meditacao_sombria", type: .cultist, rarity: 4),
        Card(name: "Blood Offering", faithCost: 5, heresyCost: 2, followersEffect: 12, effectsDescription: "", description: "Demands loyalty through sacrifice.", imageName: "oferta", type: .cultist, rarity: 6)
    ]

    let heresyCards: [Card] = [
        Card(name: "Spread Doubts", faithCost: 2, heresyCost: 0, followersEffect: -5, effectsDescription: "", description: "Shakes the followers' faith.", imageName: "duvida", type: .heresy, rarity: 2),
        Card(name: "Sabotage Ritual", faithCost: 3, heresyCost: 0, followersEffect: -8, effectsDescription: "", description: "Weakens the cultists.", imageName: "sabotar", type: .heresy, rarity: 5),
        Card(name: "Whisper Lies", faithCost: 2, heresyCost: 1, followersEffect: -4, effectsDescription: "", description: "Turns trust into confusion.", imageName: "mentiras", type: .heresy, rarity: 3),
        Card(name: "Infiltrate Cult", faithCost: 4, heresyCost: 2, followersEffect: -10, effectsDescription: "", description: "Breaks inner ranks.", imageName: "infiltracao", type: .heresy, rarity: 6)
    ]

    let assassinationCard = Card(name: "Assassination", faithCost: 5, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "Eliminates a player.", imageName: "assassinato", type: .assassination, rarity: 10)
    
    var specialCards: [SpecificCard] = []

    init() {
        setupCards()
    }

    func setupCards() {
        let churchRitual = SpecificCard(
            name: "Church Ritual",
            faithCost: 2,
            followersEffect: 5,
            heresyCost: 0, effectsDescription: "",
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
            heresyCost: 0, effectsDescription: "",
            description: "Adds 15 followers after 4 rounds",
            imageName: "fe",
            type: .common,
            rarity: 1,
            isActive: true
        )

        burstOfFaith.specialAbility = { [weak burstOfFaith] vm in
            guard let card = burstOfFaith else { return }
            card.isActive = true
            card.rotationCount += 1
            
            if !vm.activeCards.contains(where: { $0.id == card.id }) {
                vm.activeCards.append(card)
                vm.activeCards = vm.activeCards
                print(vm.activeCards)
            }

            if card.rotationCount <= 4 {
                print("wait a little")
            } else {
                vm.followers += card.followersEffect
                card.isActive = false
            }
        }

        let forbiddenKnowledge = SpecificCard(
            name: "Forbidden Knowledge",
            faithCost: 3,
            followersEffect: 0,
            heresyCost: 3, effectsDescription: "",
            description: "After 3 turns, adds 10 followers and 2 heresy.",
            imageName: "conhecimento",
            type: .cultist,
            rarity: 5,
            isActive: true
        )

        forbiddenKnowledge.specialAbility = { [weak forbiddenKnowledge] vm in
            guard let card = forbiddenKnowledge else { return }
            card.isActive = true
            card.rotationCount += 1
            
            if !vm.activeCards.contains(where: { $0.id == card.id }) {
                vm.activeCards.append(card)
            }

            if card.rotationCount >= 3 {
                vm.followers += 10
                vm.points += 2
                card.isActive = false
            }
        }

        cultistCards.append(churchRitual)
        cultistCards.append(burstOfFaith)
        cultistCards.append(forbiddenKnowledge)
    }
}
