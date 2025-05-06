import Foundation
import SwiftUICore
import GameKit
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject, GKMatchDelegate, GKLocalPlayerListener {
    static let shared = MultiplayerManager()
    
    @Published var match: GKMatch?
    @Published var isHosting: Bool = false
    @Published var connectedPlayers: [GKPlayer] = []
    @Published var globalState = GlobalGameState(sharedFaithPoints: 30, heresyPoints: [:], followers: 50)
    @Published var matchAvailable = false
    
    private override init() { super.init() }

    func startHosting(matchRequest: GKMatchRequest = GKMatchRequest()) {
        isHosting = true
        matchRequest.minPlayers = 2
        matchRequest.maxPlayers = 7
        GKMatchmaker.shared().findMatch(for: matchRequest) { match, error in
            if let match = match {
                self.match = match
                match.delegate = self
                print("conectando")
            } else if let error = error {
                print("Error hosting match: \(error.localizedDescription)")
            }
        }
    }

    func joinMatchUsingViewController() {
        isHosting = false

        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 7

        let mmvc = GKMatchmakerViewController(matchRequest: request)
        mmvc?.matchmakerDelegate = self

        if let vc = mmvc {
            rootViewController?.present(vc, animated: true)
        }
    }

    // Send data to all players (used by host)
    func sendDataToAllPlayers(_ data: Data, reliably: Bool = true) {
        guard let match = match else { return }
        try? match.sendData(toAllPlayers: data, with: reliably ? .reliable : .unreliable)
    }

    // Send data to host only (used by clients)
    func sendDataToHost(_ data: Data, reliably: Bool = true) {
        guard let match = match else { return }
        if let host = match.players.first {
            try? match.send(data, to: [host], dataMode: reliably ? .reliable : .unreliable)
        }
    }

    // MARK: - GKMatchDelegate
    
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        NotificationCenter.default.post(name: .didReceiveGameData, object: data)
    }

    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .connected:
            connectedPlayers.append(player)
        case .disconnected:
            connectedPlayers.removeAll { $0 == player }
        default:
            break
        }
    }
    
    func receiveData(_ data: Data, from player: GKPlayer) {
        do {
            let action = try JSONDecoder().decode(CardPlayAction.self, from: data)

            DispatchQueue.main.async {
                if action.playerRole == .cultist {
                    // Deduz pontos de fé compartilhados
                    self.globalState.sharedFaithPoints -= action.card.faithCost
                } else {
                    // Armazena pontos de heresia por jogador
                    self.globalState.heresyPoints[player.playerID, default: 0] += action.card.faithCost
                }

                // Atualiza seguidores
                self.globalState.followers += action.card.followersEffect

                self.sendGlobalStateToAllPlayers()
            }

        } catch {
            print("Erro ao decodificar ação do jogador: \(error)")
        }
    }
    
    func sendGlobalStateToAllPlayers() {
        guard let data = try? JSONEncoder().encode(globalState) else { return }

        try? match?.sendData(toAllPlayers: data, with: .reliable)
    }
    
    func send(_ action: CardPlayAction) {
        guard let data = try? JSONEncoder().encode(action) else { return }
        try? match?.sendData(toAllPlayers: data, with: .reliable)
    }
    
    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
    
    func authenticatePlayer() {
        // Set the authentication handler that GameKit invokes.
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // If the view controller is non-nil, present it to the player so they can
                // perform some necessary action to complete authentication.
                self.rootViewController?.present(viewController, animated: true) { }
                return
            }
            if let error {
                // If you can’t authenticate the player, disable Game Center features in your game.
                print("Error: \(error.localizedDescription).")
                return
            }
        
            // Register for real-time invitations from other players.
            GKLocalPlayer.local.register(self)
            
            // Add an access point to the interface.
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = true
            
            // Enable the Start Game button.
            self.matchAvailable = true
        }
    }
}

extension Notification.Name {
    static let didReceiveGameData = Notification.Name("didReceiveGameData")
}

extension MultiplayerManager: GKMatchmakerViewControllerDelegate {
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker failed: \(error.localizedDescription)")
        viewController.dismiss(animated: true)
    }

    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        self.match = match
        match.delegate = self
        print("Match joined successfully")
        viewController.dismiss(animated: true)
    }
}
