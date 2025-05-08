import SwiftUI

struct HostGameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var errorMessage: String?

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
            if gameStarted {
                GameStatusView()
                        .transition(.slide)
            }
        }
        .onAppear {
            multiplayerManager.startHosting()
        }
    }

    func assignRoles() {
        var players = multiplayerManager.connectedPeers.shuffled()
        guard let herege = players.popLast() else {
            errorMessage = "Error assigning heretic role!"
            return
        }

        var roles: [String: PlayerRole] = [herege.displayName: .heretic]
        for peer in players {
            roles[peer.displayName] = .cultist
        }

        self.playerRoles = roles
        for (peerName, role) in roles {
            if let peer = multiplayerManager.connectedPeers.first(where: { $0.displayName == peerName }) {
                multiplayerManager.sendRole(role, to: peer)
            }
        }
    }
}

#Preview {
    HostGameView()
}
