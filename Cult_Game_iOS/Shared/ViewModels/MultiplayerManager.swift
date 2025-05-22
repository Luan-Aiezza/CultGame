import Foundation
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject {
    
    //MARK
    static let shared = MultiplayerManager()
    
    @Published var hostPeerID: MCPeerID?
    
    @Published private var availableCharacters: [Character] = [.fox, .panda, .bunny, .tiger, .deer, .pig, .wolf]
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
    
    private let serviceType = "cult-game"
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    
    private var _myPeerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
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
    
//    func handleReceivedData(_ data: Data, from peerID: MCPeerID) {
//        if let phase = try? JSONDecoder().decode(GamePhase.self, from: data) {
//            DispatchQueue.mainasync {
//                self.currentPhase = phase
//            }
//        }
//    }
    
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
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    func sendGlobalStateToAllPlayers() {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = try? JSONEncoder().encode(globalState) {
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
        }
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
            print("\n🎯 Ação recebida do jogador \(peerID.displayName): carta \(action.card.name)")
            
            if action.playerRole == .cultist {
                print("🙏 Reduzindo fé em \(action.card.faithCost)")
                self.globalState.sharedFaithPoints -= action.card.faithCost
            } else {
                print("🔥 Aumentando heresia de \(action.card.faithCost)")
                self.globalState.heresyPoints[peerID.displayName, default: 0] += action.card.faithCost
            }
            
            print("👥 Alterando seguidores em \(action.card.followersEffect)")
            self.globalState.followers += action.card.followersEffect
            
            print("📬 Novo estado global: \n - Fé: \(self.globalState.sharedFaithPoints)\n - Heresia total: \(self.globalState.heresyPoints.values.reduce(0, +))\n - Seguidores: \(self.globalState.followers)")
            
            self.sendGlobalStateToAllPlayers()
            NotificationCenter.default.post(name: .didReceiveGameData, object: nil)
            
            
            GameViewModel().checkVictoryConditions() //precisa estar vinculada ao mesmo GameViewModel do host,
        }
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
    
//    func assignCharactersRandomly(to players: [MCPeerID]) {
//        let allCharacters: [Character] = [.fox, .panda, .bunny, .tiger, .deer, .pig, .wolf]
//        let shuffledCharacters = allCharacters.shuffled()
//        
//        for (index, player) in players.enumerated() {
//            if index < shuffledCharacters.count {
//                let character = shuffledCharacters[index]
//                sendCharacter(character, to: player)
//            } else {
//                print("⚠️ Mais jogadores do que personagens disponíveis!")
//            }
//        }
//    }
    
    func sendCharacter(_ character: Character, to peer: MCPeerID) {
        let message = MultiplayerMessage.characterAssignment(character)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    public func sendRole(_ role: PlayerRole, to peer: MCPeerID) {
        let message = MultiplayerMessage.roleAssignment(role)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    // Função criada para eliminar um jogador do jogo
    
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
                self.connectedPeers.append(peerID)
                self.players[peerID] = PlayerModel()
                
                if !self.availableCharacters.isEmpty {
                    let character = self.availableCharacters.removeFirst()
                    self.sendCharacter(character, to: peerID)
                    print("👤 Atribuído personagem \(character) para \(peerID.displayName)")
                } else {
                    print("⚠️ Sem personagens disponíveis para \(peerID.displayName)")
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
            case .characterAssignment(let character):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didReceiveCharacter, object: character)
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
                    }
                }
            case .updatePlayers(let decoded):
                DispatchQueue.main.async {
                    let updated = decoded.mapKeys { displayName in
                        self.connectedPeers.first(where: { $0.displayName == displayName }) ?? MCPeerID(displayName: displayName)
                    }
                    self.players = updated
                }
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
            try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
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
}

#if DEBUG
extension MultiplayerManager {
    func _setFakePeerID(_ fakeID: MCPeerID) {
        self._myPeerID = fakeID
    }
}
#endif

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        Dictionary<T, Value>(uniqueKeysWithValues: self.map { (transform($0.key), $0.value) })
    }
}
