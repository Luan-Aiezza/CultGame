//
//  GameViewModel+Elimination.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 15/05/25.
//

import Foundation
import MultipeerConnectivity

extension GameViewModel {
    
    func addVote(to peerID: String) {
        print("entrou em mandar votos")
        if var player = multiplayerManager.players[peerID] {
            player.votes += 1
            multiplayerManager.players[peerID] = player
            print("mandando voto para \(peerID) que agora está com \(player.votes) votos")
            multiplayerManager.sendPlayersToAll()
        }
    }
    
    func turnPlayerInactive(to peerID: String) {
        let message = MultiplayerMessage.setInactive(peerID)
        multiplayerManager.sendMessage(message)
        
        if var player = multiplayerManager.players[peerID] {
            player.state = .inactive
            multiplayerManager.players[peerID] = player
        }
    }
    
    func kill(peer : String) {
        multiplayerManager.eliminateKilled(peerID: peer)
        turnPlayerInactive(to: peer)
        multiplayerManager.sendPlayersToAll()
        
        if peerID == peer {
            setState(state: .inactive)
        }
    }
    
    func evaluateVotes() {
        let votePairs = multiplayerManager.players.map { (peerID, player) in
            (peerID, player.votes)
        }

        print("📥 Votos recebidos:")
        for (id, count) in votePairs {
            print("- \(id): \(count) votos")
        }

        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }

        print("🏆 Top votado(s): \(topVoted), maxVotes: \(maxVotes)")
        
        if maxVotes < 1 {
            return
        }

        if topVoted.count == 1, let toEliminate = topVoted.first {
            eliminatedPlayer = toEliminate
            
            multiplayerManager.eliminateVoted(peerID: toEliminate)
            turnPlayerInactive(to: toEliminate)
            multiplayerManager.sendPlayersToAll()
            
            if peerID == toEliminate {
                setState(state: .inactive)
            }

        } else {
            isTie = true
            multiplayerManager.voted = nil
        }
        // Resetar votos
        for (peerID, var player) in multiplayerManager.players {
            player.votes = 0
            multiplayerManager.players[peerID] = player
        }

        self.didEvaluate = true
    }
}

extension Notification.Name {
    static let didReceiveSetInactive = Notification.Name("didReceiveSetInactive")
}
