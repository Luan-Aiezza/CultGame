import Foundation


#warning("Cara de ChatGPT....")
// Gerenciador responsável por distribuir cartas aos jogadores, controlando os baralhos e reciclagem de cartas.
class CardDistributionManager: ObservableObject {
    
    //singleton
    static let shared = CardDistributionManager(deckSource: CardDeck())
    
    // Baralhos principais — são embaralhados e distribuídos aos jogadores.
    @Published var commonDeck: [Card]
    @Published var cultistDeck: [Card]
    @Published var heresyDeck: [Card]

    // Pilhas de descarte usadas para reembaralhar quando os baralhos acabam.
    private var usedCommon: [Card] = []
    private var usedCultist: [Card] = []
    private var usedHeresy: [Card] = []

    // Carta única de assassinato usada exclusivamente por hereges.
    let assassinationCard: Card
    
    // Fonte original do baralho, contendo todas as cartas disponíveis.
    let deckSource: CardDeck

    // Inicializa os baralhos com muitas cópias embaralhadas das cartas originais (25x para garantir volume).
    init(deckSource: CardDeck) {
        self.deckSource = deckSource
        self.commonDeck = Array(repeating: deckSource.commonCards, count: 25).flatMap { $0 }.shuffled()
        self.cultistDeck = Array(repeating: deckSource.cultistCards, count: 25).flatMap { $0 }.shuffled()
        self.heresyDeck = Array(repeating: deckSource.heresyCards, count: 25).flatMap { $0 }.shuffled()
        self.assassinationCard = deckSource.assassinationCard
    }

    // Distribui a mão inicial de acordo com o papel do jogador.
    func dealInitialHand(for role: PlayerRole) -> [Card] {
        switch role {
        case .cultist:
            // 2 comuns + 1 de cultista
            return drawCards(types: [.common, .common, .cultist])
        case .heretic:
            // 2 comuns + 2 heresias + 1 carta de assassinato fixa
            return drawCards(types: [.common, .common, .heresy, .heresy]) + [assassinationCard]
        }
    }

    // Repõe a mão do jogador ao fim do turno com base na carta usada.
    func replenishHand(_ hand: [Card], usedCard: Card?) -> Card? {
        guard let card = usedCard else { return nil}

        // Se a carta ainda estiver na mão (por erro), não faz nada.
        if hand.contains(where: { $0.id == card.id }) {
            return nil
        }

        // Move a carta usada para a pilha de descarte.

        // Sorteia nova carta do mesmo tipo da usada e adiciona à mão.
        switch card.type {
        case .common:
            if let newCard = drawCardWithChance(from: &commonDeck, usedPile: &usedCommon) {
                addUsedCard(card)
                return newCard
            }
        case .cultist:
            if let newCard = drawCardWithChance(from: &cultistDeck, usedPile: &usedCultist) {
                print("inserindo \(newCard) no deck")
                return newCard
                //addUsedCard(card) | nao sera incluida nos used se estiver ativa
            }
        case .heresy:
            if let newCard = drawCardWithChance(from: &heresyDeck, usedPile: &usedHeresy) {
                addUsedCard(card)
                return newCard
            }
        default:
            break // cartas especiais (como assassinato) não são repostas aqui
        }
        
        return nil
    }

    // Sorteia uma lista de cartas com base em uma sequência de tipos.
    private func drawCards(types: [CardType]) -> [Card] {
        types.compactMap { type in
            switch type {
            case .common:
                return drawCardWithChance(from: &commonDeck, usedPile: &usedCommon)
            case .cultist:
                return drawCardWithChance(from: &cultistDeck, usedPile: &usedCultist)
            case .heresy:
                return drawCardWithChance(from: &heresyDeck, usedPile: &usedHeresy)
            default:
                return nil
            }
        }
    }
    
    

    // Reembaralha o baralho a partir da pilha de descarte.
    private func reshuffle(_ deck: inout [Card], from used: inout [Card]) {
        deck = used.shuffled()
        used.removeAll()
    }

    // Move uma carta usada para sua respectiva pilha de descarte.
    private func addUsedCard(_ card: Card) {
        switch card.type {
        case .common: usedCommon.append(card)
        case .cultist: usedCultist.append(card)
        case .heresy: usedHeresy.append(card)
        case .empty: break
        default: break
        }
    }
    
    //sortei uma carta baseada na nsua raridade.
    private func drawCardWithChance(from deck: inout [Card], usedPile: inout [Card]) -> Card? {
        
        var totalChance = 0
        
        for (index, _) in deck.enumerated() {
            totalChance += Int(deck[index].rarity)
        }
        
        let randomChance = Int.random(in: 1...totalChance)
        
        if deck.isEmpty {
            reshuffle(&deck, from: &usedPile)
        }
        
        for (index, _) in deck.enumerated() {
            if deck[index].rarity > randomChance {
                deck[index].rarity -= 1
                return deck[index]
            }
        }
        
        guard let card = deck.popLast() else {return nil}
        
        return card
    }
}
