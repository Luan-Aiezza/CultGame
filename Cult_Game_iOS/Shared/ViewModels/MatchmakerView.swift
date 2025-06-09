import SwiftUI
import GameKit

struct MatchmakerView: UIViewControllerRepresentable {
    func makeCoordinator() -> GameKitMultiplayerManager {
        return GameKitMultiplayerManager.shared
    }

    func makeUIViewController(context: Context) -> GKMatchmakerViewController {
        let request = GKMatchRequest()
        request.minPlayers = 1
        request.maxPlayers = 7

        let vc = GKMatchmakerViewController(matchRequest: request)!
        vc.matchmakerDelegate = GameKitMultiplayerManager.shared as? any GKMatchmakerViewControllerDelegate
        return vc
    }

    func updateUIViewController(_ uiViewController: GKMatchmakerViewController, context: Context) {}
}
