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
            return
        }

        guard points >= card.faithCost else {
            return
        }

        assignCard(card: card)
        removeCardFromHand(card: card)

        card.play(vm: self)

        print("""
        🃏 Carta jogada: \(card.name)
        ✝️ Fé: \(globalState.sharedFaithPoints)
        🔥 Heresia: \(globalState.heresyPoints[peerID.displayName, default: 0])
        👥 Fiéis: \(globalState.followers)
        """)

        turnEnteredCardPlayOnce()
        checkVictoryConditions()
    }

    func skipCard() {
        guard player.usedCard != nil else {
            return
        }
        
        let action = CardPlayAction(playerID: peerID.displayName, card: emptyCard, playerRole: player.role!)

        if isHost {
            multiplayerManager.handleReceived(action, from: peerID)
        } else {
            multiplayerManager.send(action)
        }

        turnEmptyCard()
    }

    func playAllActiveCards() {
        activeCards.removeAll { $0.isActive == false }
        for card in activeCards {
            card.play(vm: self)
        }
    }
}
