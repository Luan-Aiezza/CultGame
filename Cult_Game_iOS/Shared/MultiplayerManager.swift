import Foundation
import GameKit
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject, GKMatchDelegate {
    static let shared = MultiplayerManager()
    
    @Published var match: GKMatch?
    @Published var isHost: Bool = false
    @Published var connectedPlayers: [GKPlayer] = []
    @Published var globalState = GlobalGameState(sharedFaithPoints: 30, heresyPoints: [:], followers: 50)
    
    private override init() { super.init() }

    func startHosting(matchRequest: GKMatchRequest = GKMatchRequest()) {
        isHost = true
        matchRequest.minPlayers = 5
        matchRequest.maxPlayers = 7
        GKMatchmaker.shared().findMatch(for: matchRequest) { match, error in
            if let match = match {
                self.match = match
                match.delegate = self
            } else if let error = error {
                print("Error hosting match: \(error.localizedDescription)")
            }
        }
    }

    func joinMatch(matchRequest: GKMatchRequest = GKMatchRequest()) {
        isHost = false
        matchRequest.minPlayers = 5
        matchRequest.maxPlayers = 7
        GKMatchmaker.shared().findMatch(for: matchRequest) { match, error in
            if let match = match {
                self.match = match
                match.delegate = self
            } else if let error = error {
                print("Error joining match: \(error.localizedDescription)")
            }
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
}

extension Notification.Name {
    static let didReceiveGameData = Notification.Name("didReceiveGameData")
}
