import Foundation

extension GameViewModel {
    
    func selectRole(_ selectedRole: PlayerRole) {
        assignRole(selectedRole)
    }
    
    func advancePhaseAfterTimer() {
        switch multiplayerManager.currentPhase {
        case .pairing:
            print("current phase: \(multiplayerManager.currentPhase)")
            currentPhase = .roleSelection
            multiplayerManager.currentPhase = .roleSelection
            multiplayerManager.sendGamePhase(.roleSelection)
        case .roleSelection:
            print("current phase: \(multiplayerManager.currentPhase)")
            currentPhase = .cardPlay
            multiplayerManager.currentPhase = .cardPlay
            multiplayerManager.sendGamePhase(.cardPlay)
        case .cardPlay:
            print("current phase: \(multiplayerManager.currentPhase)")
            multiplayerManager.killed = nil
            multiplayerManager.voted = nil
            checkIfShouldAdvancePhase()
        case .discussion:
            print("current phase: \(multiplayerManager.currentPhase)")
            evaluateVictory()
            currentPhase = .elimination
            multiplayerManager.currentPhase = .elimination
            multiplayerManager.sendGamePhase(.elimination)
        case .elimination:
            print("current phase: \(multiplayerManager.currentPhase)")
            currentPhase = .eliminationResults
            multiplayerManager.currentPhase = .eliminationResults
            multiplayerManager.sendGamePhase(.eliminationResults)
        case .eliminationResults:
            print("current phase: \(multiplayerManager.currentPhase)")
            evaluateVictory()
            if multiplayerManager.currentPhase == .roleSelection {
                return
            }
            currentPhase = .cardPlay
            multiplayerManager.currentPhase = .cardPlay
            multiplayerManager.sendGamePhase(.cardPlay)
        default:
            break
        }
    }
    
    func handlePhaseChange() {
        
        if isHost, case .cardPlay = multiplayerManager.currentPhase {
            evaluateVictory()
        }

        switch multiplayerManager.currentPhase {
            case .cardPlay:
            if player.hasEnteredCardPlayOnce {
                globalState.heresyPoints += 10
                if globalState.heresyPoints > 20{
                    globalState.heresyPoints = 20
                }
            }
            turnEnteredCardPlayOnce()
            replenishHandIfNeeded()
            multiplayerManager.goToNextRound()
            playAllActiveCards()

            if player.usedCard == nil {
                turnEmptyCard()
            }

        default: break
        }
    }
    
    private func checkIfShouldAdvancePhase() {
        let activePlayers = multiplayerManager.players.filter { $0.value.state == .active }
        if activePlayers.count >= 3 {
            currentPhase = .discussion
            multiplayerManager.currentPhase = .discussion
            multiplayerManager.sendGamePhase(.discussion)
        } else {
            // Caso não haja jogadores suficientes, pode colocar lógica adicional ou finalizar a partida
            print("Não há jogadores ativos suficientes para continuar.")
            evaluateVictory()
        }
    }
}
