//
//  GameViewModel+Elimination.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 15/05/25.
//

import Foundation
import GameKit

extension GameViewModel {

    func addVote(to peerID: String) {
        if var player = multiplayer.players[peerID] {
            player.votes += 1
            multiplayer.players[peerID] = player
            multiplayer.sendPlayersToAll()
        }
    }

    func turnPlayerInactive(to peerID: String) {
        if var player = multiplayer.players[peerID] {
            player.state = .inactive
            multiplayer.players[peerID] = player
            multiplayer.sendPlayersToAll()
        }
    }

    func kill(peer: String) {
        multiplayer.eliminateKilled(peerID: peer)
        turnPlayerInactive(to: peer)
        
        if peerID == peer {
            setState(state: .inactive)
        }
    }

    func evaluateVotes() {
        let votePairs = multiplayer.players.map { ($0.key, $0.value.votes) }

        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }

        if maxVotes < 1 { return }

        if topVoted.count == 1, let toEliminate = topVoted.first {
            eliminatedPlayer = toEliminate
            multiplayer.eliminateVoted(peerID: toEliminate)
            turnPlayerInactive(to: toEliminate)
            
            if peerID == toEliminate {
                setState(state: .inactive)
            }
        } else {
            isTie = true
            multiplayer.voted = nil
        }

        // Resetar votos
        for (peerID, var player) in multiplayer.players {
            player.votes = 0
            multiplayer.players[peerID] = player
        }

        self.didEvaluate = true
    }
}
