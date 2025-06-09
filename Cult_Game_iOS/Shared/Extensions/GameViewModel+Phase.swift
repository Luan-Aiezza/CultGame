
import Foundation

extension GameViewModel {

    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
    }

    func advancePhaseAfterTimer() {
        switch multiplayer.currentPhase {
        case .pairing:
            currentPhase = .roleSelection
        case .roleSelection:
            currentPhase = .cardPlay
        case .cardPlay:
            multiplayer.killed = nil
            multiplayer.voted = nil
            currentPhase = .discussion
        case .discussion:
            evaluateVictory()
            currentPhase = .elimination
        case .elimination:
            currentPhase = .eliminationResults
        case .eliminationResults:
            evaluateVictory()
            currentPhase = .cardPlay
        default:
            break
        }

        multiplayer.currentPhase = currentPhase
        multiplayer.sendGamePhase(currentPhase)
    }

    func handlePhaseChange() {
        if isHost, multiplayer.currentPhase == .cardPlay {
            evaluateVictory()
        }

        switch multiplayer.currentPhase {
        case .cardPlay:
            if player.hasEnteredCardPlayOnce {
                globalState.heresyPoints += 10
            }
            turnEnteredCardPlayOnce()
            replenishHandIfNeeded()
            multiplayer.goToNextRound()
            playAllActiveCards()

            if player.usedCard == nil {
                turnEmptyCard()
            }

        default: break
        }
    }
}
