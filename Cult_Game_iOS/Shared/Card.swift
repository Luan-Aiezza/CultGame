import SwiftUI

//ESTRUTURA DAS CARTAS
class Card: Identifiable, Equatable, Codable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id : UUID
    let name: String
    let faithCost: Int
    let followersEffect: Int // Pode ser positivo (cultistas) ou negativo (herege)
    let description: String
    let imageName: String
    let type: CardType
    
    init(name: String, faithCost: Int, followersEffect: Int, description: String, imageName: String, type: CardType) {
        self.id = UUID()
        self.name = name
        self.faithCost = faithCost
        self.followersEffect = followersEffect
        self.description = description
        self.imageName = imageName
        self.type = type
    }
    
    func play(vm : GameViewModel){
        guard vm.points >= faithCost else { return }
        vm.points -= faithCost
        vm.followers += followersEffect

        if type != .assassination {
            vm.usedCard = self
            vm.playerHand.removeAll { $0.id == self.id }
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

//INSTANCIA DE CARTAS MANUAIS (PROVISORIO)

public class CardDeck {
    
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
    
    var specialCards: [SpecificCard] = []

    init() {
        setupCards()
    }

    func setupCards() {
        let churchRitual = SpecificCard(
            name: "Church Ritual",
            faithCost: 2,
            followersEffect: 5,
            description: "Continues to add 5 followers every turn",
            imageName: "orar",
            type: .common,
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
            description: "Adds 15 followers after 4 rounds",
            imageName: "fe",
            type: .common,
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

        specialCards = [churchRitual, burstOfFaith]
    }
}


