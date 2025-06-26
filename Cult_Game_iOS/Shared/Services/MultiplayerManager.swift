import Foundation
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject {
    
    //MARK: Singleton
    static let shared = MultiplayerManager()
    
    
    //MARK: Connection
    private let serviceType = "cult-game"
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    public let myPeerID = MCPeerID(displayName: "\(UIDevice.current.name)_\(UUID().uuidString.prefix(4))")
    var isHosting: Bool = false
    
    @Published var hostPeerID: MCPeerID?
    @Published var connectedPeers: [MCPeerID] = []
    
    
    //MARK: Game Central
    @Published var players: [String: PlayerModel] = [:]
    @Published var globalState = GlobalGameState(
        sharedFaithPoints: GameRules.initialFaithPoints,
        heresyPoints: GameRules.initialHeresy,
        followers: GameRules.initialFollowers
    )
    @Published var round = 0
    @Published var currentPhase: GamePhase = .pairing
    @Published var pendingEffects: [GameEffects] = []
    @Published var killed : PlayerModel? = nil
    @Published var voted : PlayerModel? = nil
    @Published var outcome: GameOutcome? = nil

    private override init() {
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    
    
    //MARK: Game Central -> Mensagens
    
    // carta
    func send(_ action: CardPlayAction) {
        
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(action) {
            let stablePeers = self.connectedPeers
            try? session.send(data, toPeers: stablePeers, with: .reliable)
        }
    }
    
    //global state
    func sendGlobalStateToAllPlayers() {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(globalState) {
            let stablePeers = self.connectedPeers
            try? session.send(data, toPeers: stablePeers, with: .reliable)        }
    }
    
    //votado
    func eliminateVoted(peerID : String) {
        let message = MultiplayerMessage.vote(peerID)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    //eliminado
    func eliminateKilled(peerID : String) {
        let message = MultiplayerMessage.vote(peerID)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    //fase do jogo
    func sendGamePhase(_ phase: GamePhase) {
        let message = MultiplayerMessage.attPhase(phase)
        sendMessage(message)
        
        DispatchQueue.main.async {
            self.currentPhase = phase
        }
    }
    
    //personagem
    func addCharacter(to peerID: MCPeerID) {
        
        // a TV assina personagens -> se o ID for o mesmo, não mandará personagens
        guard peerID != myPeerID else { return }
        if players[peerID.displayName]?.character != nil { return }
        
        //bloqueia outras TV's
        if peerID.displayName.contains("Apple TV") {
            return
        }
        
        
        //Manda um personagem um player
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            let usedCharacters = self.players.values.compactMap { $0.character }
            let availableCharacters = Character.allCases.filter { !usedCharacters.contains($0) }
            guard let character = availableCharacters.first else {
                return
            }
            
            if let peer = self.connectedPeers.first(where: { $0.displayName == peerID.displayName }),
               var player = self.players[peer.displayName] {
                player.character = character
                self.players[peer.displayName] = player
                print("player: \(player)")
                self.sendPlayersToAll()
            }
        }
    }

    //vitória
    func sendVictory(_ outcome: GameOutcome) {
        let message = MultiplayerMessage.victory(outcome)
        sendMessage(message)
    }
    
    //papel
    public func sendRole(_ role: PlayerRole, to peer: MCPeerID) {
        var player = players[peer.displayName]
        player?.role = role
        players[peer.displayName] = player
        
        sendPlayersToAll()
        print("players atualmente: \(players)")
        
        let message = MultiplayerMessage.roleAssignment(role)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    //eliminação
    func eliminate(peer: MCPeerID) {
        let message = MultiplayerMessage.kickPlayer
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    func goToNextRound() {
        round += 1
    }
    
    
    //MARK: Connection -> funções
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
    
    func disconnect() {
        session.cancelConnectPeer(myPeerID)
    }
    
    func disconnectAll() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session.disconnect()
        connectedPeers.removeAll()
    }
    
    func handleReceived(_ data: Data, from peerID: String) {
        if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
            handleReceived(action, from: peerID)
        }
    }
    
    func handleReceived(_ action: CardPlayAction, from peerID: String) {
        
        print("recebi uma carta: \(action.card.name)")
        
        DispatchQueue.main.async {
            let faithChange =  action.card.faithCost
            let heresyChange = action.card.faithCost
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
        
        print("entrou em pending effects")
        
        
        for effect in pendingEffects {
            if effect.faithChange != 0 {
                globalState.sharedFaithPoints += effect.faithChange
                
                if globalState.sharedFaithPoints < 0 {
                    globalState.sharedFaithPoints = 0
                }
                
            }
            
            if effect.heresyChange != 0 {
                globalState.heresyPoints += effect.heresyChange
                
                if globalState.heresyPoints < 0 {
                    globalState.heresyPoints = 0
                }
                
            }
            
            globalState.followers += effect.followersChange
            
            if globalState.followers < 0 {
                globalState.followers = 0
            }
        }
        pendingEffects.removeAll()
        sendGlobalStateToAllPlayers()
        NotificationCenter.default.post(name: .didReceiveGameData, object: nil)
    }
}

extension MultiplayerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectedPeers.append(peerID)
                
                if peerID.displayName.contains("Apple TV") {
                    return
                }
            
                if self.players[peerID.displayName] == nil {
                    self.players[peerID.displayName] = PlayerModel()
                }
                
                if self.isHosting {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if self.session.connectedPeers.contains(peerID) {
                            if self.players[peerID.displayName]?.character == nil {
                                self.addCharacter(to: peerID)
                            }
                        }
                    }
                }

            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
                self.players.removeValue(forKey: peerID.displayName)
                
            default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard !session.connectedPeers.isEmpty else {
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
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5)  {
                    if let peer = self.connectedPeers.first(where: { $0.displayName == peerDisplayName }),
                       
                        var player = self.players[peer.displayName] {
                        player.character = character
                        self.players[peer.displayName]?.character = character
                        self.sendPlayersToAll()
                    }
                }
            case .kickPlayer:
                DispatchQueue.main.async {
                    MultiplayerManager.shared.disconnect()
                }
                
            case .vote(let peerDisplayName):
                DispatchQueue.main.async {
                    if let player = self.players[peerDisplayName] {
                        self.voted = player
                        self.sendPlayersToAll()
                    }
                }
                //ERA MUITO SIMPLES >:C
            case .setInactive(let peerDisplayName):
                DispatchQueue.main.async {
                    if var player = self.players[peerDisplayName] {
                        player.state = .inactive
                        self.players[peerDisplayName] = player
                        self.sendPlayersToAll()
                    }
                    
                    //Se eu sou o eliminado, notifico para alterar meu próprio estado
                    if peerDisplayName == self.myPeerID.displayName {
                        NotificationCenter.default.post(name: .didReceiveSetInactive, object: nil)
                    }
                }
            case .updatePlayers(let decoded):
                DispatchQueue.main.async {
                    self.players = decoded
                }
            case .victory(let outcome):
                DispatchQueue.main.async {
                    self.outcome = outcome
                    NotificationCenter.default.post(name: .didReceiveVictory, object: outcome)
                }
            case .kill(let peerDisplayName):
                DispatchQueue.main.async {
                    if let player = self.players[peerDisplayName] {
                        self.killed = player
                        self.sendPlayersToAll()
                    }
                }
            }
        } else {
            print("recebeu ALGO")
            handleReceived(data, from: peerID.displayName)
        }
    }
    
    func sendPlayersToAll() {
        guard !session.connectedPeers.isEmpty else { return }
        let message = MultiplayerMessage.updatePlayers(players)
        sendMessage(message)
    }
    
    // Métodos exigidos mas não utilizados
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
    func sendMessage(_ message: MultiplayerMessage) {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(message) {
            let stablePeers = self.connectedPeers
            try? session.send(data, toPeers: stablePeers, with: .reliable)
        }
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
    static let didReceiveVictory = Notification.Name("didReceiveVictory")
    static let didReceiveSetInactive = Notification.Name("didReceiveSetInactive")
}
