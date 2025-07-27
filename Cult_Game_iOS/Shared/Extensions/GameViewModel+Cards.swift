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
        
        // Impede jogar cartas caso não haja pontos suficientes
        //CHECAR
        switch card.type {
        case .heresy, .assassination:
            if globalState.heresyPoints < abs(card.heresyCost) {
                print("Não há pontos de heresia suficientes!")
                return
            }
        case .cultist, .common:
            if globalState.sharedFaithPoints < abs(card.faithCost) {
                print("Não há pontos de fé suficientes!")
                return
            }
        default:
            break
        }

        assignCard(card: card)
        removeCardFromHand(card: card)

        card.play(vm: self)
        turnEnteredCardPlayOnce()
    }

    func skipCard() {
        guard player.usedCard != nil else {
            return
        }
        
        let action = CardPlayAction(playerID: peerID, card: emptyCard, playerRole: player.role!)

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

