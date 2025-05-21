
import Foundation

extension GameViewModel {
    
    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
        receiveInitialCards()
        currentPhase = .cardPlay
    }
    
    func advancePhaseAfterTimer() {
        switch currentPhase {
        case .cardPlay:
            currentPhase = .discussion
            multiplayerManager.currentPhase = .discussion
            multiplayerManager.sendGamePhase(.discussion)
        case .discussion:
            currentPhase = .elimination
            multiplayerManager.currentPhase = .elimination
            multiplayerManager.sendGamePhase(.elimination)
        case .elimination:
            currentPhase = .eliminationResults
            multiplayerManager.currentPhase = .eliminationResults
            multiplayerManager.sendGamePhase(.eliminationResults)
        case .eliminationResults:
            currentPhase = .cardPlay
            multiplayerManager.currentPhase = .cardPlay
            multiplayerManager.sendGamePhase(.cardPlay)
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
