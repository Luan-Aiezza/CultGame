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
}
