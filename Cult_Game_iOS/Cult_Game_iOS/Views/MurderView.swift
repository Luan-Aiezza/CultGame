import SwiftUI
import GameKit

struct MurderView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = GameKitMultiplayerManager.shared
    
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0

    var myCharacter: Character? {
        let myID = multiplayerManager.localPlayer.playerID
        return multiplayerManager.players[myID]?.character
    }

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
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                    .transition(.opacity)

                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(
                            colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    .ignoresSafeArea()
                    .scaledToFill()

                VStack {
                    Spacer()

                    Text("Escolha alguém para matar")
                        .multilineTextAlignment(.center)
                        .font(.custom("VinerHandITC", size: 34))
                        .foregroundColor(.title)
                        .padding(.bottom, 24)

                    LazyVGrid(columns: columns, spacing: verticalSpacing) {
                        ForEach(
                            multiplayerManager.players.filter { (playerID, player) in
                                player.character != myCharacter && player.state == .active
                            }.sorted(by: { $0.key < $1.key }),
                            id: \.key
                        ) { playerID, player in
                            PlayerCellView(
                                player: player,
                                isSelected: selectedPlayerID == playerID,
                                glowRotation: $glowRotation,
                                onSelect: {
                                    if selectedPlayerID == playerID {
                                        selectedPlayerID = nil
                                        glowRotation = 0
                                    } else {
                                        selectedPlayerID = playerID
                                        voteConfirmed = false
                                        glowRotation = 0
                                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                                            glowRotation = 360
                                        }
                                    }
                                },
                                width: cardWidth,
                                height: cardHeight
                            )
                        }
                    }
                    .padding(.top, 20)

                    Spacer(minLength: 520)
                }
                .padding(.horizontal, horizontalPadding)

                // Botão Done
                Button(action: {
                    if let playerID = selectedPlayerID {
                        voteConfirmed = true
                        vm.kill(peer: playerID)
                        print("Assassinou \(playerID)")
                        DispatchQueue.main.async {
                            print(multiplayerManager.players)
                        }
                    }
                }) {
                    Text("Done")
                        .font(.custom("Almendra-Regular", size: 26))
                        .foregroundColor(selectedPlayerID == nil ? Color("disable") : Color("title_color"))
                        .padding(.horizontal, 73)
                        .padding(.vertical, 13)
                        .background(
                            Image(selectedPlayerID == nil ? "buttonDisable" : "buttonEnable")
                                .resizable()
                                .renderingMode(.original)
                                .cornerRadius(12)
                        )
                        .fixedSize()
                }
                .disabled(selectedPlayerID == nil)
                .position(x: geometry.size.width / 2, y: geometry.size.height - 85)
            }
        }
    }
}
