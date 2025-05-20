
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
            currentPhase = .elimination
        case .elimination:
            currentPhase = .eliminationResults
        case .eliminationResults:
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
            print("hand antes: \(player.hand)")
            replenishHandIfNeeded()
            print("hand depois: \(player.hand)")
            addRound()
            playAllActiveCards()

            if player.usedCard == nil {
                turnEmptyCard()
                print("turn empty card foi ativado durante handle phase")
            }

        default: break
        }
    }

    func addRound() {
        round += 1
    }

    func proceedToDiscussionIfReady() {
        currentPhase = .discussion
        if player.usedCard == nil {
            turnEmptyCard()
        }
    }
}
