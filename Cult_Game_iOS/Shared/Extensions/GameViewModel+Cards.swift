//
//  GameViewModel+Cards.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

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
        guard player.usedCard == nil || player.usedCard?.type == .empty else {
            print("⚠️ Você já jogou uma carta este turno.")
            return
        }

        guard points >= card.faithCost else {
            print("⚠️ Pontos insuficientes para usar a carta.")
            return
        }

        assignCard(card: card)
        removeCardFromHand(card: card)

        card.play(vm: self) // envia para host

        print("""
        🃏 Carta jogada: \(card.name)
        ✝️ Fé: \(globalState.sharedFaithPoints)
        🔥 Heresia: \(globalState.heresyPoints[peerID.displayName, default: 0])
        👥 Fiéis: \(globalState.followers)
        """)

        // Impede skip
        turnEnteredCardPlayOnce()

        proceedToDiscussionIfReady()
        checkVictoryConditions()
    }

    func skipCard() {
        if player.usedCard != nil && player.usedCard?.type != .empty {
            print("❌ Não é possível skipar agora")
            return
        }

        print("⏭ Rodada skipada")

        let action = CardPlayAction(playerID: peerID.displayName, card: emptyCard, playerRole: player.role!)

        if isHost {
            multiplayerManager.handleReceived(action, from: peerID)
        } else {
            multiplayerManager.send(action)
        }

        turnEmptyCard()

        if currentPhase == .cardPlay {
            currentPhase = .discussion
        } else if currentPhase == .discussion {
            currentPhase = .cardPlay
            playAllActiveCards()
        }
    }




    func playAllActiveCards() {
        activeCards.removeAll { $0.isActive == false }
        for card in activeCards {
            card.play(vm: self)
        }
    }
}
