import SwiftUI
import MultipeerConnectivity

struct MurderView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0
    var myCharacter: Character? {
        let myDisplayName = viewModel.multiplayerManager.myPeerID.displayName
        let character = viewModel.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
        print("Meu personagem atual: \(String(describing: character))")
        print("Meu peer \(viewModel.multiplayerManager.myPeerID)")
        print("Meu display Name \(viewModel.multiplayerManager.myPeerID)")
        
        print(viewModel.multiplayerManager.players)
        print(viewModel.multiplayerManager.players[viewModel.multiplayerManager.myPeerID.displayName] ?? "dad" )
        return character
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

                VStack {
                    Spacer()

                    Text("Escolha alguém para matar")
                        .multilineTextAlignment(.center)
                        .font(.custom("VinerHandITC", size: 34))
                        .foregroundColor(.title)
                        .padding(.bottom, 24)

                    LazyVGrid(columns: columns, spacing: verticalSpacing) {
                        ForEach(
                            multiplayerManager.players.filter { (peerID, player) in
                                let isNotMyPeer = player.character != myCharacter
                                let isActive = player.state == .active
                                return isNotMyPeer && isActive
                            },
                            id: \.key
                        ) { peerID, player in
                            let playerID = player.id
                            PlayerCellView(
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

                    Spacer(minLength: 220)
                }
                .padding(.horizontal, horizontalPadding)

                // Botão
                Button(action: {
                    voteConfirmed = true
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

#Preview {
    MurderView()
}

// MARK: - Mock para preview e testes locais

let mockPlayers: [PlayerModel] = [
    PlayerModel(
        id: "1",
        hand: [Card(name: "Preach", faithCost: 2, heresyCost: 0, followersEffect: 4, effectsDescription: "", description: "Inspires hope.", imageName: "preach", type: .common, rarity: 2)],
        role: .cultist,
        personalHeresyPoints: 1,
        state: .active,
        character: .fox
    ),
    PlayerModel(
        id: "2",
        hand: [Card(name: "Question Faith", faithCost: 0, heresyCost: 2, followersEffect: -3, effectsDescription: "", description: "Sows doubt.", imageName: "question", type: .common, rarity: 3)],
        role: .cultist,
        personalHeresyPoints: 3,
        state: .active,
        character: .panda
    ),
    PlayerModel(
        id: "3",
        hand: [Card(name: "Fast", faithCost: 1, heresyCost: 0, followersEffect: 1, effectsDescription: "", description: "Shows devotion.", imageName: "fast", type: .common, rarity: 4)],
        role: .cultist,
        personalHeresyPoints: 0,
        state: .active,
        character: .bunny
    ),
    PlayerModel(
        id: "4",
        hand: [Card(name: "Whisper Heresy", faithCost: 0, heresyCost: 3, followersEffect: -4, effectsDescription: "", description: "Spreads doubt.", imageName: "whisper", type: .common, rarity: 2)],
        role: .cultist,
        personalHeresyPoints: 5,
        state: .active,
        character: .tiger
    ),
    PlayerModel(
        id: "5",
        hand: [Card(name: "Light Candles", faithCost: 1, heresyCost: 0, followersEffect: 2, effectsDescription: "", description: "Symbolic ritual.", imageName: "candles", type: .common, rarity: 1)],
        role: .cultist,
        personalHeresyPoints: 0,
        state: .active,
        character: .deer
    ),
    PlayerModel(
        id: "6",
        hand: [Card(name: "Blaspheme", faithCost: 0, heresyCost: 4, followersEffect: -5, effectsDescription: "", description: "Shocks the faithful.", imageName: "blaspheme", type: .common, rarity: 1)],
        role: .heretic,
        personalHeresyPoints: 6,
        state: .active,
        character: .pig
    )
]

