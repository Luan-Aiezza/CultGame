import SwiftUI
import MultipeerConnectivity

struct EliminationView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0

    private let horizontalPadding: CGFloat = 26
    private let horizontalSpacing: CGFloat = 18
    private let verticalSpacing: CGFloat = 34
    private let cardHeight: CGFloat = 68

    private var columns: [GridItem] {
        [GridItem(.flexible(), spacing: horizontalSpacing),
         GridItem(.flexible(), spacing: horizontalSpacing)]
    }

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2) - horizontalSpacing
            let cardWidth = availableWidth / 2

            ZStack {
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()

                VStack {
                    Spacer()

                    Text("Quem é Herege?")
                        .multilineTextAlignment(.center)
                        .font(.custom("VinerHandITC", size: 34))
                        .foregroundColor(.title)
                        .padding(.bottom, 24)

                    LazyVGrid(columns: columns, spacing: verticalSpacing) {
                        ForEach(mockPlayers.filter { $0.state == .active }, id: \.id) { player in
                            PlayerElimView(
                                player: player,
                                isSelected: player.id == selectedPlayerID,
                                glowRotation: $glowRotation,
                                onSelect: {
                                    selectedPlayerID = player.id
                                    voteConfirmed = false
                                    glowRotation = 0 // reinicia rotação
                                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                                        glowRotation = 360
                                    }
                                },
                                width: cardWidth,
                                height: cardHeight
                            )
                        }
                    }
                    .padding(.top, 20)

                    Spacer(minLength: 320)
                }
                .padding(.horizontal, horizontalPadding)

                HStack(spacing: 22) {
                    Button(action: {
                        //TODO: Adicionar tela da Mari
                    }) {
                        Text("Skip")
                            .font(.custom("Almendra-Regular", size: 26))
                            .foregroundColor(Color("title_color"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                Image("buttonEnable")
                                    .resizable()
                                    .renderingMode(.original)
                                    .cornerRadius(12)
                            )
                    }

                    // Botão Done
                    Button(action: {
                        voteConfirmed = true
                        //TODO: Adicionar tela da Mari
                    }) {
                        Text("Done")
                            .font(.custom("Almendra-Regular", size: 26))
                            .foregroundColor(selectedPlayerID == nil ? Color("disable") : Color("title_color"))
                            .padding(.vertical, 13)
                            .frame(maxWidth: .infinity)
                            .background(
                                Image(selectedPlayerID == nil ? "buttonDisable" : "buttonEnable")
                                    .resizable()
                                    .renderingMode(.original)
                                    .cornerRadius(12)
                            )
                    }
                    .disabled(selectedPlayerID == nil)
                }
                .padding(.horizontal, 48)
                .frame(maxWidth: .infinity)

                .position(x: geometry.size.width / 2, y: geometry.size.height - 85)
            }
        }
    }
}

#Preview {
    EliminationView()
}

//
//struct EliminationView: View {
//    @ObservedObject var multiplayerManager = MultiplayerManager.shared
//    @EnvironmentObject var viewModel: GameViewModel
//    
//    @State private var selectedPeer: MCPeerID? = nil
//    @State private var voteConfirmed = false
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("Selecione um jogador para eliminar")
//                .font(.headline)
//                .padding(.top)
//            
//            ForEach(multiplayerManager.connectedPeers.filter {
//                let isNotMyPeer = $0 != multiplayerManager.myPeerID
//                let isNotTV = !$0.displayName.contains("TV")
//                let isActive = multiplayerManager.players[$0]?.state == .active
//                return isNotMyPeer && isNotTV && isActive
//            }, id: \.self) { peer in
//                if let player = multiplayerManager.players[peer] {
//                    Button(action: {
//                        selectedPeer = peer
//                        voteConfirmed = false
//                    }) {
//                        HStack {
//                            Text(peer.displayName)
//                                .fontWeight(peer == selectedPeer ? .bold : .regular)
//                                .foregroundColor(.primary)
//                            Spacer()
//                            Text(player.role?.rawValue.capitalized ?? "Sem papel")
//                                .foregroundColor(.secondary)
//                        }
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(peer == selectedPeer ? Color.red : Color.gray.opacity(0.2), lineWidth: peer == selectedPeer ? 2 : 1)
//                                .background(
//                                    peer == selectedPeer ? Color.red.opacity(0.1) : Color.clear
//                                )
//                        )
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            
//            if let selected = selectedPeer {
//                Text("Selecionado: \(selected.displayName)")
//                    .foregroundColor(.red)
//                    .padding(.top, 10)
//                
//                if !voteConfirmed {
//                    Button("Confirmar Voto") {
//                        if multiplayerManager.players[selected] != nil {
//                            viewModel.addVote(to: selected)
//                            voteConfirmed = true
//                        }
//                    }
//                    .padding(.top, 5)
//                } else {
//                    Text("Voto confirmado!")
//                        .foregroundColor(.green)
//                        .font(.subheadline)
//                }
//            }
//            
//            Spacer()
//            
//            Button("Voltar para Discussão") {
//                viewModel.currentPhase = .discussion
//            }
//            .padding()
//            
//            Button("Ir para Jogada de Cartas") {
//                viewModel.currentPhase = .cardPlay
//            }
//            .padding()
//        }
//        .padding()
//    }
//}
