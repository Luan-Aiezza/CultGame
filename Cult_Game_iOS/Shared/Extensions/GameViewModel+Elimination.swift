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
        guard var player = multiplayerManager.players[peerID] else { return }
        player.votes += 1
        multiplayerManager.players[peerID] = player
        print("voto adicionado!")
        if(peerID == multiplayerManager.myPeerID) {
            attPlayer(newPlayer: player)
        }
    }
    
    func turnPlayerInactive(to peerID: MCPeerID) {
        guard var player = multiplayerManager.players[peerID] else { return }
        player.state = .inactive
        multiplayerManager.players[peerID] = player
        if(peerID == multiplayerManager.myPeerID) {
            attPlayer(newPlayer: player)
        }
    }
}
