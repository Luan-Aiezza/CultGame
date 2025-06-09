//
//  GameViewModel+Cards.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

import Foundation
import SwiftUI

extension GameViewModel {
    
    func replenishHandIfNeeded() {
        var idealCardNumber = 0
        
        switch player.role {
        case .cultist:
            idealCardNumber = 3
        case .heretic:
            idealCardNumber = 5
        default:
            break
        }
        
        let needed = idealCardNumber - player.hand.count
        guard needed > 0 else { return }

        if let card = deckManager.replenishHand(player.hand, usedCard: player.usedCard) {
            addCard(pool: [card], needed: needed)
        }
    }

    func playCard(_ card: Card) {
        guard player.usedCard == nil else { return }

        assignCard(card: card)
        removeCardFromHand(card: card)

        let action = CardPlayAction(playerID: peerID, card: card, playerRole: player.role!)
        multiplayer.send(action)
        
        turnEnteredCardPlayOnce()
    }

    func skipCard() {
        guard player.usedCard == nil else { return }

        let action = CardPlayAction(playerID: peerID, card: emptyCard, playerRole: player.role!)
        multiplayer.send(action)
        
        turnEmptyCard()
    }

    func playAllActiveCards() {
        activeCards.removeAll { !$0.isActive }
        for card in activeCards {
            card.play(vm: self)
        }
    }
}
