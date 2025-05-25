
import Foundation

extension GameViewModel {
    
    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
    }
    
    func advancePhaseAfterTimer() {
        switch multiplayerManager.currentPhase {
        case .pairing:
            currentPhase = .roleSelection
            multiplayerManager.currentPhase = .roleSelection
            multiplayerManager.sendGamePhase(.roleSelection)
        case .roleSelection:
            currentPhase = .cardPlay
            multiplayerManager.currentPhase = .cardPlay
            multiplayerManager.sendGamePhase(.cardPlay)
        case .cardPlay:
            multiplayerManager.killed = nil
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
            evaluateVictory()//////////////////////
        default:
            break
        }
    }
    
    func handlePhaseChange() {
        
        if isHost, case .cardPlay = multiplayerManager.currentPhase {
            evaluateVictory()////////////////////////////////
        }

        switch multiplayerManager.currentPhase {
            case .cardPlay:
            if player.hasEnteredCardPlayOnce {
                globalState.heresyPoints[peerID.displayName, default: 0] += 1000
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
}
