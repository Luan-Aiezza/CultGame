//
//  GameViewModel+MultiplayerSinc.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 13/05/25.
//

import Foundation

extension GameViewModel {
    
    @objc func syncState() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    @objc func handleRoleAssignment(_ notification: Notification) {
        if let role = notification.object as? PlayerRole {
            DispatchQueue.main.async {
                self.assignRole(role)
                self.receiveInitialCards()
                self.currentPhase = .cardPlay
            }
        }
    }
}
