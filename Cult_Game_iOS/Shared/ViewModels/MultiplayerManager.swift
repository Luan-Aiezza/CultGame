import Foundation
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject {
    
    //singleton
    static let shared = MultiplayerManager()
    
    @Published var hostPeerID: MCPeerID?
    
    @Published var assignedRoles: [MCPeerID: PlayerRole] = [:]
    @Published var playerStates: [MCPeerID: PlayerModel] = [:]
    @Published var connectedPeers: [MCPeerID] = []
    @Published var players: [MCPeerID: PlayerModel] = [:]
    @Published var globalState = GlobalGameState(
        sharedFaithPoints: 5,
        heresyPoints: [:],
        followers: GameRules.initialFollowers
    )
    @Published var round = 0
    @Published var currentPhase: GamePhase = .pairing
    @Published var pendingEffects: [GameEffects] = []
    @Published var killed : PlayerModel? = PlayerModel(id: "", hand: [], usedCard: nil, role: .cultist, personalHeresyPoints: 0, hasEnteredCardPlayOnce: true, state: .active, votes: 0, character: .panda)
    
    private let serviceType = "cult-game"
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    
    public let myPeerID = MCPeerID(displayName: "\(UIDevice.current.name)_\(UUID().uuidString.prefix(4))")
    
    var isHosting: Bool = false
    
    private override init() {
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func sendGamePhase(_ phase: GamePhase) {
        let message = MultiplayerMessage.attPhase(phase)
        sendMessage(message)
        
        DispatchQueue.main.async {
            self.currentPhase = phase
        }
    }
    
    func addCharacter(to peerID: MCPeerID) {
        
        print ("adicionando para \(peerID.displayName)")
        guard peerID != myPeerID else { return }
        // Se este for o primeiro player conectado, atribuímos diretamente o personagem .fox
        if players[peerID]?.character != nil { return }
        
        if peerID.displayName.contains("Apple TV") {
            return
        }
        
        let usedCharacters = self.players.values.compactMap { $0.character }
        let availableCharacters = Character.allCases.filter { !usedCharacters.contains($0) }
        guard let character = availableCharacters.first else {
            print("⚠️ Sem personagens disponíveis para \(peerID.displayName)")
            return
        }
        DispatchQueue.main.async {
            if let peer = self.connectedPeers.first(where: { $0.displayName == peerID.displayName }),
               
                var player = self.players[peer] {
                player.character = character
                self.players[peer]?.character = character
                self.sendPlayersToAll()
                print("Players com personagem")
                print("\(peerID.displayName) recebeu \(character)")
                print(self.players)
                self.sendPlayersToAll()
            }
        }
    }

    func sendVictory(_ outcome: GameOutcome) {
        let message = MultiplayerMessage.victory(outcome)
        sendMessage(message)///////////////////////////victory
    }

    func startHosting() {
        isHosting = true
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        hostPeerID = myPeerID // <- define como host
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func joinSession() {
        isHosting = false
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func goToNextRound() {
        round += 1
    }
    
    func send(_ action: CardPlayAction) {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(action) {
            let stablePeers = session.connectedPeers.filter { peer in
                self.players[peer] != nil
            }
            try? session.send(data, toPeers: stablePeers, with: .reliable)        }
    }
    
    func sendGlobalStateToAllPlayers() {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(globalState) {
            let stablePeers = session.connectedPeers.filter { peer in
                self.players[peer] != nil
            }
            try? session.send(data, toPeers: stablePeers, with: .reliable)        }
    }
    
    func getRoles(for peers: [MCPeerID]) -> [MCPeerID: PlayerRole] {
        var result: [MCPeerID: PlayerRole] = [:]
        for peer in peers {
            if let role = assignedRoles[peer] {
                result[peer] = role
            }
        }
        return result
    }
    
    func getPlayerStates(for peers: [MCPeerID]) -> [MCPeerID: PlayerModel] {
        var result: [MCPeerID: PlayerModel] = [:]
        for peer in peers {
            if let state = playerStates[peer] {
                result[peer] = state
            }
        }
        return result
    }
    
    // Função criada para quando um player está tentando conectar ao jogo mas não pode mais entrar. Ex: O limite de jogadores foi atingido e mais um player está tentando entrar na partida.
    
    
    func disconnect() {
        session.cancelConnectPeer(myPeerID)
    }
    
    func disconnectAll() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session.disconnect()
        connectedPeers.removeAll()
    }
    
    func handleReceived(_ data: Data, from peerID: MCPeerID) {
        if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
            handleReceived(action, from: peerID)
        }
    }
    
    func handleReceived(_ action: CardPlayAction, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            let faithChange = action.playerRole == .cultist ? -action.card.faithCost : 0
            let heresyChange = action.playerRole == .heretic ? action.card.faithCost : 0
            let followersChange = action.card.followersEffect
            let effect = GameEffects(
                peerID: peerID,
                faithChange: faithChange,
                heresyChange: heresyChange,
                followersChange: followersChange
            )

            self.pendingEffects.append(effect)
        }
    }
    
    func applyPendingEffects() {
        for effect in pendingEffects {
            if effect.faithChange != 0 {
                globalState.sharedFaithPoints += effect.faithChange
            }
            
            if effect.heresyChange != 0 {
                globalState.heresyPoints[effect.peerID.displayName, default: 0] += effect.heresyChange
            }
            
            globalState.followers += effect.followersChange
        }
        
        pendingEffects.removeAll()
        sendGlobalStateToAllPlayers()
        NotificationCenter.default.post(name: .didReceiveGameData, object: nil)
    }
    
    
    
    
    func assignRolesRandomly(to players: [MCPeerID]) {
        let shuffled = players.shuffled()
        if let heretic = shuffled.first {
            sendRole(.heretic, to: heretic)
        }
        for cultist in shuffled.dropFirst() {
            sendRole(.cultist, to: cultist)
        }
    }
    
    public func sendRole(_ role: PlayerRole, to peer: MCPeerID) {
        let message = MultiplayerMessage.roleAssignment(role)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    func eliminate(peer: MCPeerID) {
        let message = MultiplayerMessage.kickPlayer
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
}

extension MultiplayerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
//                guard peerID != self.myPeerID else { return } // <- impede adicionar a si mesmo
                if peerID.displayName.contains("Apple TV") {
                    return
                }
                
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                }
                // Garantir que o player já existe antes de atribuir personagem
                if self.players[peerID] == nil {
                    self.players[peerID] = PlayerModel()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    print("Player sem personagem")
                    print(self.players)
                    if self.session.connectedPeers.contains(peerID) {
                        self.addCharacter(to: peerID)
                    }
                }
                
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
                self.players.removeValue(forKey: peerID)
                
            default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        //        print("👥 Peers conectados: \(session.connectedPeers)")
        guard !session.connectedPeers.isEmpty else {
            print("⚠️ Nenhum peer conectado")
            return
        }
        if let message = try? JSONDecoder().decode(MultiplayerMessage.self, from: data) {
            switch message {
            case .attPhase(let phase):
                DispatchQueue.main.async {
                    self.currentPhase = phase
                }
            case .roleAssignment(let role):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didReceiveRole, object: role)
                }
            case .characterAssignment(let peerDisplayName):
                let usedCharacters = self.players.values.compactMap { $0.character }
                let availableCharacters = Character.allCases.filter { !usedCharacters.contains($0) }
                guard let character = availableCharacters.first else {
                    print("⚠️ Sem personagens disponíveis para \(peerID.displayName)")
                    return
                }
                DispatchQueue.main.async {
                    if let peer = self.connectedPeers.first(where: { $0.displayName == peerDisplayName }),
                       
                        var player = self.players[peer] {
                        player.character = character
                        self.players[peer]?.character = character
                        self.sendPlayersToAll()
                        print(self.players)
                    }
                }
            case .kickPlayer:
                DispatchQueue.main.async {
                    MultiplayerManager.shared.disconnect()
                }
                
            case .vote(let peerDisplayName):
                DispatchQueue.main.async {
                    if let peer = self.connectedPeers.first(where: { $0.displayName == peerDisplayName }),
                       var player = self.players[peer] {
                        player.votes += 1
                        self.players[peer] = player
                        self.sendPlayersToAll()
                    }
                }
            case .setInactive(let peerDisplayName):
                DispatchQueue.main.async {
                    if let peer = self.connectedPeers.first(where: { $0.displayName == peerDisplayName }),
                       var player = self.players[peer] {
                        player.state = .inactive
                        self.players[peer] = player
                        self.killed = player
                    }
                }
            case .updatePlayers(let decoded):
                DispatchQueue.main.async {
                    let updated = decoded.mapKeys { displayName in
                        self.connectedPeers.first(where: { $0.displayName == displayName }) ?? MCPeerID(displayName: displayName)
                    }
                    self.players = updated
                }
            case .victory(let outcome):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didReceiveVictory, object: outcome)
                }////////////////////////
            }
        } else {
            handleReceived(data, from: peerID)
        }
    }
    
    func sendPlayersToAll() {
        guard !session.connectedPeers.isEmpty else { return }
        let serializablePlayers = players.mapKeys { $0.displayName }
        let message = MultiplayerMessage.updatePlayers(serializablePlayers)
        sendMessage(message)
    }
    
    // Métodos exigidos mas não utilizados
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    func sendMessage(_ message: MultiplayerMessage) {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(message) {
            let stablePeers = session.connectedPeers.filter { peer in
                self.players[peer] != nil
            }
            try? session.send(data, toPeers: stablePeers, with: .reliable)        }
    }
}

extension MultiplayerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("📡 Convite recebido de: \(peerID.displayName)")
        invitationHandler(true, session)
    }
}

extension MultiplayerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("🔍 Encontrou peer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}

extension Notification.Name {
    static let didReceiveGameData = Notification.Name("didReceiveGameData")
    static let didReceiveRole = Notification.Name("didReceiveRole")
    static let didReceiveCharacter = Notification.Name("didReceiveCharacter")
    static let didReceiveVictory = Notification.Name("didReceiveVictory")////////////////
}

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: self.map { (transform($0.key), $0.value) })
    }
}
