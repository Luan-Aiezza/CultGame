import Foundation

extension GameViewModel {
    
    func replenishHandIfNeeded() {
        let needed = 3 - player.hand.count
        guard needed > 0 else { return }

        var pool: [Card] = []

        switch player.role {
        case .cultist:
            guard let card = deckManager.replenishHand(player.hand, usedCard: player.usedCard) else {return}
            pool.append(card)
        case .heretic:
            guard let card = deckManager.replenishHand(player.hand, usedCard: player.usedCard) else {return}
            pool.append(card)
        default:
            break
        }
        addCard(pool: pool, needed: needed)
    }

    func playCard(_ card: Card) {
        guard player.usedCard != nil else {
            print("you've already played a card this round")
            return
        }

        guard points >= card.faithCost else { return }

        let action = CardPlayAction(playerID: peerID.displayName, card: card, playerRole: player.role!)

        if isHost {
            multiplayerManager.handleReceived(try! JSONEncoder().encode(action), from: peerID)
        } else {
            multiplayerManager.send(action)
        }

        if card.type != .assassination {
            assignCard(card: card)
            removeCardFromHand(card: card)

        } else {
            assignCard(card: card)
        }

        card.play(vm: self)
        proceedToDiscussionIfReady()
    }

    func skipCard() {
        guard player.usedCard != nil else {
            print("you've already chosen a card this round")
            return
        }

        let action = CardPlayAction(playerID: peerID.displayName, card: player.usedCard!, playerRole: player.role!)

        if isHost {
            multiplayerManager.handleReceived(try! JSONEncoder().encode(action), from: peerID)
        } else {
            multiplayerManager.send(action)
        }
        turnEmptyCard()
        proceedToDiscussionIfReady()
    }

    func playAllActiveCards() {
        activeCards.removeAll { $0.isActive == false }
        for card in activeCards {
            card.play(vm: self)
        }
    }
}
