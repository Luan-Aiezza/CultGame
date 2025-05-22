
import Foundation

extension GameViewModel {
    
    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
        currentPhase = .cardPlay
    }
    
    func advancePhaseAfterTimer() {
        switch multiplayerManager.currentPhase {
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
            evaluateVictory()//////////////////////

        default:
            break
        }
    }
    
    func handlePhaseChange() {
        
        if isHost, case .cardPlay = currentPhase {
            evaluateVictory()////////////////////////////////
        }

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
