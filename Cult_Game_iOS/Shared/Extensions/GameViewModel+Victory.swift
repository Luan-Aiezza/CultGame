//
//  GameViewModel+Victory.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 01/06/25.
//

import SwiftUI

extension GameViewModel {

    @objc func handleVictory(_ notification: Notification) {
        if let outcome = notification.object as? GameOutcome {
            self.gameOutcome = outcome
            self.currentPhase = .victory(outcome)
            multiplayer.sendGamePhase(.victory(outcome))
        }
    }

    func evaluateVictory() {
        let players = multiplayer.players

        let cultists = players.filter { $0.value.role == .cultist && $0.value.state == .active }
        let heretics = players.filter { $0.value.role == .heretic && $0.value.state == .active }

        var outcome: GameOutcome?

        if multiplayer.globalState.followers >= GameRules.maxFollowers {
            outcome = .cultistVictoryFollowers
        } else if heretics.isEmpty {
            outcome = .cultistVictoryElimination
        } else if multiplayer.globalState.followers <= 0 {
            outcome = .hereticVictoryFollowers
        } else if heretics.count >= cultists.count {
            outcome = .hereticVictoryBalance
        }

        if let outcome {
            multiplayer.sendVictory(outcome)
            self.gameOutcome = outcome
            multiplayer.currentPhase = .victory(outcome)
            multiplayer.sendGamePhase(.victory(outcome))
        } else {
            advancePhaseAfterTimer()
        }
    }
}
