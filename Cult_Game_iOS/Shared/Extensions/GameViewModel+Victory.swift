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
            multiplayerManager.sendGamePhase(.victory(outcome))
        }
    }
    
    #warning("Retirar prints depois de debuggado a função")
    func evaluateVictory() {
        
        print("entrou em evaluate victory")
        
        let players = multiplayerManager.players
        print("players: \(players)")
        
        let cultists = players.filter { (_, player) in
            player.role == .cultist && player.state == .active
        }
        
        let heretics = players.filter { (_, player) in
            player.role == .heretic && player.state == .active
        }
        
        var outcome: GameOutcome?

        if multiplayerManager.globalState.followers >= GameRules.maxFollowers {
            outcome = .cultistVictoryFollowers
        } else if heretics.isEmpty {
            outcome = .cultistVictoryElimination
        } else if multiplayerManager.globalState.followers <= 0 {
            outcome = .hereticVictoryFollowers
        } else if heretics.count >= cultists.count {
            outcome = .hereticVictoryBalance
        }

        if let outcome {
            print("🏁 Vitória detectada: \(outcome)")
            multiplayerManager.sendVictory(outcome)

            self.gameOutcome = outcome
            multiplayerManager.currentPhase = .victory(outcome)
            multiplayerManager.sendGamePhase(.victory(outcome))
        } else {
            print("🔄 Nenhuma vitória detectada")
            advancePhaseAfterTimer()
        }
        
        print("chegou ao final de evaluate victory")
    }

}
