import SwiftUI
import MultipeerConnectivity

struct EliminationView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0
    @State private var showFollowTvView = false
    var myCharacter: Character? {
        let myDisplayName = viewModel.multiplayerManager.myPeerID.displayName
        let character = viewModel.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        return character
    }

    private let horizontalPadding: CGFloat = 26
    private let horizontalSpacing: CGFloat = 18
    private let verticalSpacing: CGFloat = 34
    private let cardHeight: CGFloat = 68
    
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    private var columns: [GridItem] {
        [GridItem(.flexible(), spacing: horizontalSpacing),
         GridItem(.flexible(), spacing: horizontalSpacing)]
    }

    var body: some View {
        
            let availableWidth = screenWidth - (horizontalPadding * 2) - horizontalSpacing
            let cardWidth = availableWidth / 2
            
            // Ajuste para garantir espaçamento visível mesmo em telas menores
            let minCardWidth: CGFloat = 120
            let adjustedCardWidth = max(cardWidth, minCardWidth)

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
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns, spacing: verticalSpacing) {
                        ForEach(
                            multiplayerManager.players.filter { (peerID, player) in
                                let isNotMyPeer = player.character != myCharacter
                                let isActive = player.state == .active
                                return isNotMyPeer && isActive
                            },
                            id: \.key
                        ) { peerID, player in

                            PlayerElimView(
                                player: player,
                                isSelected: peerID == selectedPlayerID,
                                glowRotation: $glowRotation,
                                onSelect: {
                                    if selectedPlayerID == peerID {
                                        // Deseleciona
                                        selectedPlayerID = nil
                                        glowRotation = 0
                                    } else {
                                        // Seleciona novo player
                                        selectedPlayerID = peerID
                                        voteConfirmed = false
                                        glowRotation = 0
                                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                                            glowRotation = 360
                                        }
                                    }
                                },
                                width: adjustedCardWidth,
                                height: cardHeight
                            )
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 520)
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
                                    .scaledToFit()
                                    .cornerRadius(12)
                            )
                    }

                    // Botão Done
                    Button(action: {
                        if let player = selectedPlayerID {
                            voteConfirmed = true
                            viewModel.addVote(to: player)
                            showFollowTvView = true
                        }
                        
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
                                    .scaledToFit()
                                    .cornerRadius(12)
                            )
                    }
                    .disabled(selectedPlayerID == nil)
                }
                .padding(.bottom, 20)
                .padding(.leading, 130)
                .padding(.trailing, 10)
                .frame(maxWidth: .infinity)

                .position(x: screenWidth / 2, y: screenHeight - 85)
                if showFollowTvView {
                    FollowTvViewVoting()
                        .transition(.opacity)
                        .zIndex(5)
                }
            }
        
    }
}

#Preview {
    EliminationView()
}
