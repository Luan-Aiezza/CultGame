//
//  GameViewModel+Phase.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

import Foundation

extension GameViewModel {
    
    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
        currentPhase = .cardPlay
    }
    
    func advancePhaseAfterTimer() {
        switch currentPhase {
        case .cardPlay:
            currentPhase = .discussion
        case .discussion:
            currentPhase = .cardPlay
        default:
            break
        }
    }
    
    func handlePhaseChange() {
        switch currentPhase {
        case .cardPlay:
            if player.hasEnteredCardPlayOnce {
                globalState.heresyPoints[peerID.displayName, default: 0] += 1
            }
            turnEnteredCardPlayOnce()
            replenishHandIfNeeded()
            addRound()
            playAllActiveCards()

            if player.usedCard == nil {
                turnEmptyCard()
            }

        default: break
        }
    }

    func addRound() {
        round += 1
    }

    func proceedToDiscussionIfReady() {
        if player.usedCard != nil {
            currentPhase = .discussion
            turnEmptyCard()
        }
    }
}
