
import SwiftUI
import MultipeerConnectivity
import SpriteKit

// MARK: - Host Game View
struct HostGameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var errorMessage: String?
    @ObservedObject private var viewModel = GameViewModel()
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Waiting for Players...")
                    .font(Font.custom("VinerHandITC", size: 30))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(multiplayerManager.connectedPeers, id: \.self) { peer in
                            VStack {
                                Text(peer.displayName.prefix(10))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                if let role = playerRoles[peer.displayName] {
                                    Text(role == .cultist ? "Cultist" : "Heretic")
                                        .foregroundColor(role == .cultist ? .green : .red)
                                } else {
                                    Text("No role")
                                        .foregroundColor(.gray)
                                }
                                if let character = viewModel.multiplayerManager.players[peer]?.character {
                                    Text( character.displayName)
                                } else {
                                    Text("No character")
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(10)
                        }
                    }
                }
                .frame(height: 200)
                
                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: startGame) {
                    Image("buttonStart")
                        //.resizable()
                        //.frame(width: 80, height: 80)
                        .foregroundColor(gameStarted ? .gray : .blue)
                }.buttonStyle(.borderless)
                .disabled(gameStarted)
                
                Text("Players connected: \(multiplayerManager.connectedPeers.count)")
                    .font(Font.custom("VinerHandITC", size: 30))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                
                Spacer()
                
                if gameStarted {
                    GameStatusView()
                        .transition(.slide)
                    
                    Spacer()
                    
                    timerView
                        .padding(.bottom)
                }
            }
            .onAppear {
                multiplayerManager.startHosting()
            }
        }
    }
    
    func startGame() {
        print(viewModel.multiplayerManager.players)
        if multiplayerManager.connectedPeers.count < 1 || multiplayerManager.connectedPeers.count > 7 {
            errorMessage = "You need to connect between 1 and 7 players"
            return
        }
        
        assignRoles()
        viewModel.currentPhase = .cardPlay
        multiplayerManager.currentPhase = .cardPlay
        multiplayerManager.sendGamePhase(.cardPlay)
        gameStarted = true
        errorMessage = nil
    }
    
    func assignRoles() {
        var players = multiplayerManager.connectedPeers.shuffled()
        
        guard let heretic = players.popLast() else {
            errorMessage = "Error assigning heretic role!"
            return
        }
        
        var roles: [MCPeerID: PlayerRole] = [heretic: .heretic]
        for peer in players {
            roles[peer] = .cultist
        }
        
        self.playerRoles = roles.mapKeys(\.displayName)
        
        for (peer, role) in roles {
            multiplayerManager.sendRole(role, to: peer)
        }
    }
    
    private var timerView: some View {
        VStack {
            Text("Phase: \(multiplayerManager.currentPhase)")
            Text("Time left: \(viewModel.timeRemaining)s")
                .font(.headline)
                .padding(8)
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(8)
        }
    }
}

// MARK: - How To Play (Placeholder)
struct HowToPlayView: View {
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            Text("Aqui vai o tutorial de como jogar.")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview
#Preview {
    HostGameView()
}
