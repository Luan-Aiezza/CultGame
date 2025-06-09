
import Foundation
import GameKit

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
            }
        }
    }

    @objc func handleCharacterAssignment(_ notification: Notification) {
        if let role = notification.object as? Character {
            DispatchQueue.main.async {
                self.assignCharacter(role)
            }
        }
    }
}
