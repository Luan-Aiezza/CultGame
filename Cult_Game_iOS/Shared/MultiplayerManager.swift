import Foundation
import MultipeerConnectivity

class MultiplayerManager: NSObject, ObservableObject {
    static let shared = MultiplayerManager()
    
    @Published var connectedPeers: [MCPeerID] = []
    @Published var globalState = GlobalGameState(sharedFaithPoints: 30, heresyPoints: [:], followers: 50)
    
    private let serviceType = "cult-game"
    
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    public let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    var isHosting: Bool = false
    
    private override init() {
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func startHosting() {
        isHosting = true
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }
    
    func joinSession() {
        isHosting = false
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
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
    
    // Função criada para quando um player está tentando conectar ao jogo mas não pode mais entrar. Ex: O limite de jogadores foi atingido e mais um player está tentando entrar na partida.

    
    func disconnect() {
        session.cancelConnectPeer(myPeerID)
    }
    
    // Função que deve ser chamada ao encerrar o host de uma partida.
    
    func disconnectAll() {
        advertiser?.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        session.disconnect()
        connectedPeers.removeAll()
    }
    
        func handleReceived(_ data: Data, from peerID: MCPeerID) {
            if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
                DispatchQueue.main.async {
                    if action.playerRole == .cultist {
                        self.globalState.sharedFaithPoints -= action.card.faithCost
                    } else {
                        self.globalState.heresyPoints[peerID.displayName, default: 0] += action.card.faithCost
                    }
                    self.globalState.followers += action.card.followersEffect
                    self.sendGlobalStateToAllPlayers()
                }
            }
        }
    
    func handleReceived(_ action: CardPlayAction, from peerID: MCPeerID) {
        DispatchQueue.main.async {
            if action.playerRole == .cultist {
                self.globalState.sharedFaithPoints -= action.card.faithCost
            } else {
                self.globalState.heresyPoints[peerID.displayName, default: 0] += action.card.faithCost
            }
            self.globalState.followers += action.card.followersEffect
            self.sendGlobalStateToAllPlayers()
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
    
    public func sendRole(_ role: PlayerRole, to peer: MCPeerID) {
        let message = MultiplayerMessage.roleAssignment(role)
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
    
    // Função criada para eliminar um jogador do jogo

    
    private func eliminate(peer: MCPeerID) {
        let message = MultiplayerMessage.kickPlayer
        if let data = try? JSONEncoder().encode(message) {
            try? session.send(data, toPeers: [peer], with: .reliable)
        }
    }
}

// MARK: - MCSessionDelegate
extension MultiplayerManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectedPeers.append(peerID)
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
            default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = try? JSONDecoder().decode(MultiplayerMessage.self, from: data) {
            switch message {
            case .roleAssignment(let role):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didReceiveRole, object: role)
                }
            case .kickPlayer:
                DispatchQueue.main.async {
                    MultiplayerManager.shared.disconnect()
                }
            }
        } else if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
            handleReceived(action, from: peerID)
        }
    }
    
    // Métodos exigidos mas não utilizados
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultiplayerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from: \(peerID.displayName)")
        invitationHandler(true, session)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultiplayerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found peer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}

// MARK: - Notification Names
extension Notification.Name {
    static let didReceiveGameData = Notification.Name("didReceiveGameData")
    static let didReceiveRole = Notification.Name("didReceiveRole")
}
