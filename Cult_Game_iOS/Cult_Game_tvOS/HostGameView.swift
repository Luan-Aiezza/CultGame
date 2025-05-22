import SwiftUI
import MultipeerConnectivity

struct HostGameView: View {
    @EnvironmentObject var multiplayerManager: MultiplayerManager
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var errorMessage: String?
    @ObservedObject private var viewModel = GameViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Waiting players...")
                .font(.title)
            
            List(multiplayerManager.connectedPeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName.prefix(10))
                    Spacer()
                    if let role = playerRoles[peer.displayName] {
                        Text(role == .cultist ? "Cultist" : "Heretic")
                            .foregroundColor(role == .cultist ? .green : .red)
                    } else {
                        Text("No role")
                            .foregroundColor(.gray)
                    }
                }
            }
            .frame(maxHeight: 300)
            
            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button("Start Game") {
                if multiplayerManager.connectedPeers.count < 1 || multiplayerManager.connectedPeers.count > 7 {
                    errorMessage = "You need to connect between 1 and 7 players"
                    return
                }
                
                assignRoles()
                multiplayerManager.sendGamePhase(.roleSelection)
                gameStarted = true
                errorMessage = nil
            }
            .disabled(gameStarted)
            .padding()
            .background(gameStarted ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Text("Players connected: \(multiplayerManager.connectedPeers.count)")
                .font(.footnote)
            
            Spacer()
            
            // Status do jogo
//            if gameStarted {
//                GameStatusView()
//                    .transition(.slide)
//                Spacer()
//                
//                timerView
//                    .padding(.bottom)
//            }
        }
        .onAppear {
            multiplayerManager.startHosting()
        }
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
        
        // Atualiza o state local para exibição (baseado em displayName)
        self.playerRoles = roles.mapKeys(\.displayName)
        
        // Envia a role diretamente para cada peer
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

#Preview {
    HostGameView()
}
