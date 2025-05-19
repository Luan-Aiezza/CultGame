import Foundation

class CardDistributionManager: ObservableObject {
    @Published var commonDeck: [Card]
    @Published var cultistDeck: [Card]
    @Published var heresyDeck: [Card]

    private var usedCommon: [Card] = []
    private var usedCultist: [Card] = []
    private var usedHeresy: [Card] = []

    let assassinationCard: Card
    let deckSource: CardDeck

    init(deckSource: CardDeck) {
        self.deckSource = deckSource
        self.commonDeck = Array(repeating: deckSource.commonCards, count: 25).flatMap { $0 }.shuffled()
        self.cultistDeck = Array(repeating: deckSource.cultistCards, count: 25).flatMap { $0 }.shuffled()
        self.heresyDeck = Array(repeating: deckSource.heresyCards, count: 25).flatMap { $0 }.shuffled()
        self.assassinationCard = deckSource.assassinationCard
    }

    func dealInitialHand(for role: PlayerRole) -> [Card] {
        switch role {
        case .cultist:
            return drawCards(types: [.common, .common, .cultist])
        case .heretic:
            return drawCards(types: [.common, .common, .heresy, .heresy]) + [assassinationCard]
        }
    }

    func replenishHand(_ hand: inout [Card], usedCard: Card?) {
        guard let card = usedCard else { return }

        if hand.contains(where: { $0.id == card.id }) {
            return // já na mão, não precisa repor
        }

        addUsedCard(card)

        switch card.type {
        case .common:
            if let newCard = drawCard(from: &commonDeck, usedPile: &usedCommon) {
                hand.append(newCard)
            }
        case .cultist:
            if let newCard = drawCard(from: &cultistDeck, usedPile: &usedCultist) {
                hand.append(newCard)
            }
        case .heresy:
            if let newCard = drawCard(from: &heresyDeck, usedPile: &usedHeresy) {
                hand.append(newCard)
            }
        default:
            break
        }
    }

    private func drawCards(types: [Card.CardType]) -> [Card] {
        types.compactMap { type in
            switch type {
            case .common:
                return drawCard(from: &commonDeck, usedPile: &usedCommon)
            case .cultist:
                return drawCard(from: &cultistDeck, usedPile: &usedCultist)
            case .heresy:
                return drawCard(from: &heresyDeck, usedPile: &usedHeresy)
            default:
                return nil
            }
        }
    }

    private func drawCard(from deck: inout [Card], usedPile: inout [Card]) -> Card? {
        if deck.isEmpty {
            reshuffle(&deck, from: &usedPile)
        }
        return deck.popLast()
    }

    private func reshuffle(_ deck: inout [Card], from used: inout [Card]) {
        deck = used.shuffled()
        used.removeAll()
    }

    private func addUsedCard(_ card: Card) {
        switch card.type {
        case .common: usedCommon.append(card)
        case .cultist: usedCultist.append(card)
        case .heresy: usedHeresy.append(card)
        default: break
        }
    }
}
