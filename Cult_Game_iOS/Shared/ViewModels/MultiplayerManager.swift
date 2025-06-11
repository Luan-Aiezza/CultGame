import Foundation
import GameKit

class GameKitMultiplayerManager: NSObject, ObservableObject {
    
    static let shared = GameKitMultiplayerManager()
    
    // MARK: - GameKit Core
    @Published var match: GKMatch?
    var isHosting: Bool = false
    var localPlayer: GKLocalPlayer { GKLocalPlayer.local }
    var connectedPlayers: [GKPlayer] = []
    var gkPlayers: [String: GKPlayer] = [:]//mudar
    
    // MARK: - Game State
    @Published var players: [String: PlayerModel] = [:]
    @Published var globalState = GlobalGameState(
        sharedFaithPoints: GameRules.initialFaithPoints,
        heresyPoints: GameRules.initialHeresy,
        followers: GameRules.initialFollowers
    )
    @Published var round = 0
    @Published var currentPhase: GamePhase = .pairing
    @Published var pendingEffects: [GameEffects] = []
    @Published var killed: PlayerModel?
    @Published var voted: PlayerModel?
    @Published var outcome: GameOutcome?
    
    // MARK: - Authentication
    func authenticateLocalPlayer(completion: @escaping (Bool) -> Void = { _ in }) {
        localPlayer.authenticateHandler = { viewController, error in
            if let vc = viewController {
                UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
            } else if self.localPlayer.isAuthenticated {
                print("✅ Game Center autenticado: \(self.localPlayer.displayName)")
                self.registerForInvites()
                completion(true)
            } else {
                print("❌ Autenticação falhou: \(error?.localizedDescription ?? "erro desconhecido")")
                completion(false)
            }
        }
    }
    
    // Localized function startMatchmaking
    func startMatchmaking(asHost: Bool, maxPlayers: Int = 8, completion: @escaping (Error?) -> Void) {
        isHosting = asHost
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = maxPlayers
        request.inviteMessage = "Junte-se à partida!"

        GKMatchmaker.shared().findMatch(for: request) { match, error in
            if let match = match {
                self.match = match
                match.delegate = self
                self.connectedPlayers = match.players
                self.setupLocalPlayer()

                if self.isHosting {
                    // Começa a procurar jogadores locais assim que a partida está pronta
                    GKMatchmaker.shared().startBrowsingForNearbyPlayers(handler: { player, reachable in
                        if reachable {
                            print("📡 Jogador encontrado: \(player.displayName)")
                            self.gkPlayers[player.gamePlayerID] = player
                            self.sendInvite(to: player)
                        } else {
                            print("❌ Jogador desconectado: \(player.displayName)")
                        }
                    })
                }

                completion(nil)
            } else {
                print("🚫 Erro ao iniciar matchmaking: \(error?.localizedDescription ?? "desconhecido")")
                completion(error)
            }
        }
    }

    
    func sendInvite(to player: GKPlayer) {
        let request = GKMatchRequest()
        request.recipients = [player]
        request.maxPlayers = 8
        request.minPlayers = 2

        guard let match = self.match else {
            print("🚫 Não há partida ativa para adicionar jogadores.")
            return
        }

        GKMatchmaker.shared().addPlayers(to: match, matchRequest: request) { error in
            if let error = error {
                print("🚫 Falha ao adicionar jogador: \(error.localizedDescription)")
            } else {
                print("✅ Jogador adicionado com sucesso")
            }
        }
    }
    
    func setupLocalPlayer() {
        let id = localPlayer.playerID
        players[id] = PlayerModel()
    }
    
    func disconnectAll() {
        match?.disconnect()
        players.removeAll()
        connectedPlayers.removeAll()
    }
    
    // MARK: - Sending Data
    
    public func send<T: Codable>(_ object: T) {
        guard let match = match else { return }
        guard let data = try? JSONEncoder().encode(object) else { return }
        
        do {
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("❌ Erro ao enviar dados: \(error.localizedDescription)")
        }
    }
    
    func sendGlobalStateToAllPlayers() {
        send(globalState)
    }
    
    func sendGamePhase(_ phase: GamePhase) {
        let message = MultiplayerMessage.attPhase(phase)
        send(message)
        DispatchQueue.main.async {
            self.currentPhase = phase
        }
    }
    
    func eliminate(peerID: String) {
        let message = MultiplayerMessage.kickPlayer
        send(message)
    }
    
    func eliminateVoted(peerID: String) {
        send(MultiplayerMessage.vote(peerID))
    }
    
    func eliminateKilled(peerID: String) {
        send(MultiplayerMessage.kill(peerID))
    }
    
    func sendVictory(_ outcome: GameOutcome) {
        send(MultiplayerMessage.victory(outcome))
    }
    
    func sendPlayersToAll() {
        send(MultiplayerMessage.updatePlayers(players))
    }
    
    func sendRole(_ role: PlayerRole, to player: GKPlayer) {
        var model = players[player.playerID]
        model?.role = role
        players[player.playerID] = model
        send(MultiplayerMessage.roleAssignment(role))
    }
    
    func goToNextRound() {
        round += 1
    }
    
    func applyPendingEffects() {
        for effect in pendingEffects {
            globalState.sharedFaithPoints = max(0, globalState.sharedFaithPoints + effect.faithChange)
            globalState.heresyPoints = max(0, globalState.heresyPoints + effect.heresyChange)
            globalState.followers = max(0, globalState.followers + effect.followersChange)
        }
        pendingEffects.removeAll()
        sendGlobalStateToAllPlayers()
        NotificationCenter.default.post(name: .didReceiveGameData, object: nil)
    }
}

extension GameKitMultiplayerManager: GKLocalPlayerListener, GKMatchmakerViewControllerDelegate {
    
    func registerForInvites() {
        GKLocalPlayer.local.register(self)
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        let mmvc = GKMatchmakerViewController(invite: invite)!
        mmvc.matchmakerDelegate = self
        
        DispatchQueue.main.async {
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.present(mmvc, animated: true)
            }
        }
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
        self.match = match
        match.delegate = self
        connectedPlayers = match.players
        setupLocalPlayer()
        
        DispatchQueue.main.async {
            viewController.dismiss(animated: true)
        }
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("❌ Matchmaker erro: \(error.localizedDescription)")
        viewController.dismiss(animated: true)
    }
}


extension GameKitMultiplayerManager: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        if let message = try? JSONDecoder().decode(MultiplayerMessage.self, from: data) {
            handleReceivedMessage(message, from: player)
        } else if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
            handleReceived(action, from: player.playerID)
        }
    }
    
    func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
        switch state {
        case .connected:
            connectedPlayers.append(player)
            if players[player.playerID] == nil {
                players[player.playerID] = PlayerModel()
            }
        case .disconnected:
            connectedPlayers.removeAll { $0 == player }
            players.removeValue(forKey: player.playerID)
        default: break
        }
    }
    
    private func handleReceivedMessage(_ message: MultiplayerMessage, from player: GKPlayer) {
        switch message {
        case .attPhase(let phase):
            currentPhase = phase
        case .vote(let peerID):
            if let player = players[peerID] {
                voted = player
                sendPlayersToAll()
            }
        case .victory(let receivedOutcome):
            outcome = receivedOutcome
            NotificationCenter.default.post(name: .didReceiveVictory, object: receivedOutcome)
        case .kickPlayer:
            disconnectAll()
        case .updatePlayers(let newPlayers):
            players = newPlayers
        case .roleAssignment(let role):
            NotificationCenter.default.post(name: .didReceiveRole, object: role)
        case .kill(let peerID):
            if let player = players[peerID] {
                killed = player
                sendPlayersToAll()
            }
        default: break
        }
    }
    
    private func handleReceived(_ action: CardPlayAction, from peerID: String) {
        let effect = GameEffects(
            playerID: peerID,
            faithChange: action.card.faithCost,
            heresyChange: action.card.faithCost,
            followersChange: action.card.followersEffect
        )
        pendingEffects.append(effect)
    }
}

