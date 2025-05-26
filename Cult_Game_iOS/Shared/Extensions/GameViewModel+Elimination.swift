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

        if topVoted.count == 1, let toEliminate = topVoted.first {
            eliminatedPlayer = toEliminate
            
            //TODO: mandar mensagem para o host atualizar multiplayerManager.host
            
            multiplayerManager.eliminateVoted(peerID: toEliminate)
            
            
            turnPlayerInactive(to: toEliminate)
            multiplayerManager.sendPlayersToAll()
            
            print("✅ Eliminado: \(eliminatedPlayer ?? "nulo")")
            print("🎯 Voted: \(multiplayerManager.voted?.character?.displayName ?? "nulo")")
        } else {
            isTie = true
            multiplayerManager.voted = nil
            print("⚖️ Empate detectado")
        }
        // Resetar votos
        for (peerID, var player) in multiplayerManager.players {
            player.votes = 0
            multiplayerManager.players[peerID] = player
        }

        self.didEvaluate = true
        
        print("✅ Estado final na função:")
        print("- eliminatedPlayer: \(eliminatedPlayer ?? "nulo")")
        print("- isTie: \(isTie)")
        print("- didEvaluate: \(didEvaluate)")
        print("- voted do multiplayer: \(multiplayerManager.voted)")
    }

}
