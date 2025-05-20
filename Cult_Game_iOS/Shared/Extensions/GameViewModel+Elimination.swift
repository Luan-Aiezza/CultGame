//
//  GameViewModel+Elimination.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 15/05/25.
//

import Foundation
import MultipeerConnectivity

extension GameViewModel {

    func addVote(to peerID: MCPeerID) {
        let message = MultiplayerMessage.vote(peerID.displayName)
        multiplayerManager.sendMessage(message)
    }
    
    func turnPlayerInactive(to peerID: MCPeerID) {
        let message = MultiplayerMessage.setInactive(peerID.displayName)
        multiplayerManager.sendMessage(message)
    }
    
    func evaluateVotes() {
        let votePairs = multiplayerManager.players.map { (peerID, player) in
            (peerID, player.votes)
        }
        
        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }
        
        if topVoted.count == 1, let toEliminate = topVoted.first {
            turnPlayerInactive(to: toEliminate)
            eliminatedPlayer = toEliminate
        } else {
            isTie = true
        }
        
        // Zera os votos de todos os jogadores
        for (peerID, var player) in multiplayerManager.players {
            player.votes = 0
            multiplayerManager.players[peerID] = player
        }
        
        // Envia o estado atualizado para todos os peers
//        multiplayerManager.sendPlayersToAll()
        
        didEvaluate = true
        
        // Será usada assim quando for passada para TV
        
        // Apenas o host deve executar esta lógica
//        guard multiplayerManager.isHosting else {
//            didEvaluate = true
//            return
//        }
//
//        let votePairs = multiplayerManager.players.map { (peerID, player) in
//            (peerID, player.votes)
//        }
//
//        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
//        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }
//
//        if topVoted.count == 1, let toEliminate = topVoted.first {
//            viewModel.turnPlayerInactive(to: toEliminate)
//            eliminatedPlayer = toEliminate
//        } else {
//            isTie = true
//        }
//
//        // Zera os votos de todos os jogadores
//        for (peerID, var player) in multiplayerManager.players {
//            player.votes = 0
//            multiplayerManager.players[peerID] = player
//        }
//
//        // Envia o estado atualizado para todos os peers
//        multiplayerManager.sendPlayersToAll()
//
//        didEvaluate = true
        
        
    }
}
