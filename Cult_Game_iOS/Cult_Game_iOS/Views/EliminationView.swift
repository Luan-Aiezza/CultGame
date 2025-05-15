import SwiftUI
import MultipeerConnectivity

struct EliminationView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var viewModel: GameViewModel

    @State private var selectedPeer: MCPeerID? = nil
    @State private var voteConfirmed = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Selecione um jogador para eliminar")
                .font(.headline)
                .padding(.top)

            ForEach(multiplayerManager.connectedPeers.filter {
                $0 != multiplayerManager.myPeerID && !$0.displayName.contains("TV")
            }, id: \.self) { peer in
                if let player = multiplayerManager.players[peer] {
                    Button(action: {
                        selectedPeer = peer
                        voteConfirmed = false
                    }) {
                        HStack {
                            Text(peer.displayName)
                                .fontWeight(peer == selectedPeer ? .bold : .regular)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(player.role?.rawValue.capitalized ?? "Sem papel")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(peer == selectedPeer ? Color.red : Color.gray.opacity(0.2), lineWidth: peer == selectedPeer ? 2 : 1)
                                .background(
                                    peer == selectedPeer ? Color.red.opacity(0.1) : Color.clear
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            if let selected = selectedPeer {
                Text("Selecionado: \(selected.displayName)")
                    .foregroundColor(.red)
                    .padding(.top, 10)

                if !voteConfirmed {
                    Button("Confirmar Voto") {
                        if let player = multiplayerManager.players[selected] {
                            viewModel.addVote(to: selected)
                            voteConfirmed = true
                        }
                    }
                    .padding(.top, 5)
                } else {
                    Text("Voto confirmado!")
                        .foregroundColor(.green)
                        .font(.subheadline)
                }
            }

            Spacer()

            Button("Voltar para Discussão") {
                viewModel.currentPhase = .discussion
            }
            .padding()

            Button("Ir para Jogada de Cartas") {
                viewModel.currentPhase = .cardPlay
            }
            .padding()
        }
        .padding()
    }
}
