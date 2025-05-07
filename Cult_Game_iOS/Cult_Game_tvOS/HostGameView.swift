import SwiftUI

struct HostGameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Aguardando jogadores...")
                .font(.title)

            List(multiplayerManager.connectedPeers, id: \.self) { peer in
                HStack {
                    Text(peer.displayName.prefix(10))
                    Spacer()
                    if let role = playerRoles[peer.displayName] {
                        Text(role == .cultist ? "Cultista" : "Herege")
                            .foregroundColor(role == .cultist ? .green : .red)
                    } else {
                        Text("Sem papel")
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

            Button("Iniciar Jogo") {
                if multiplayerManager.connectedPeers.count < 1 || multiplayerManager.connectedPeers.count > 7 {
                    errorMessage = "Você precisa de 3 a 7 jogadores para iniciar."
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

            Text("Jogadores conectados: \(multiplayerManager.connectedPeers.count)")
                .font(.footnote)

            Spacer()

            // Status do jogo
            if gameStarted {
                Text("Jogo Iniciado!")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .onAppear {
            multiplayerManager.startHosting()
        }
    }

    func assignRoles() {
        var players = multiplayerManager.connectedPeers.shuffled()
        guard let herege = players.popLast() else {
            errorMessage = "Erro ao selecionar herege"
            return
        }

        var roles: [String: PlayerRole] = [herege.displayName: .heretic]
        for peer in players {
            roles[peer.displayName] = .cultist
        }

        self.playerRoles = roles
        // Aqui você pode enviar os papéis aos peers caso necessário
    }
}

#Preview {
    HostGameView()
}
