
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
