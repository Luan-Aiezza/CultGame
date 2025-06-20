import SwiftUI
import MultipeerConnectivity

struct MurderView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0
    @State private var hasKilled: Bool = false

    var onDismiss: (() -> Void)?

    var myCharacter: Character? {
        let myDisplayName = vm.multiplayerManager.myPeerID.displayName
        let character = vm.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
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

    init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
    }

    var body: some View {
        
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .transition(.opacity)
            
            Image("background_002")
                .resizable()
                .overlay {
                    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                .scaledToFill()
            
            VStack(spacing: 0) {
                Spacer()
                
                Text("Escolha alguém para matar")
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .font(.custom("VinerHandITC", size: 34))
                    .foregroundColor(.title)
                    .padding(.bottom, 24)
                
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                        
                            LazyVGrid(columns: columns, spacing: verticalSpacing) {
                                ForEach(
                                    multiplayerManager.players.filter { (peerID, player) in
                                        let isNotMyPeer = player.character != myCharacter
                                        let isActive = player.state == .active
                                        return isNotMyPeer && isActive
                                    },
                                    id: \.key
                                ) { peerID, player in
                                    PlayerCellView(
                                        player: player,
                                        isSelected: selectedPlayerID == peerID,
                                        glowRotation: $glowRotation,
                                        onSelect: {
                                            if hasKilled {
                                                return
                                            }
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
                                        width: (geometry.size.width - (horizontalPadding * 2) - horizontalSpacing) / 2,
                                        height: cardHeight
                                    )
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 100)
                            
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, horizontalPadding)
                    }
                }

                Button(action: {
                    if let peer = selectedPlayerID, !hasKilled {
                        voteConfirmed = true
                        vm.kill(peer: peer)
                        hasKilled = true
                        print("assassinou fulano")
                        DispatchQueue.main.async {
                            print(vm.multiplayerManager.players)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            onDismiss?()
                        }
                    }
                }) {
                    Text("Done")
                        .font(.custom("Almendra-Regular", size: 26))
                        .foregroundColor((selectedPlayerID == nil || hasKilled) ? Color("disable") : Color("title_color"))
                        .padding(.horizontal, 73)
                        .padding(.vertical, 13)
                        .background(
                            Image((selectedPlayerID == nil || hasKilled) ? "buttonDisable" : "buttonEnable")
                                .resizable()
                                .renderingMode(.original)
                                .cornerRadius(12)
                        )
                        .fixedSize()
                }
                .disabled(selectedPlayerID == nil || hasKilled)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    MurderView(onDismiss: {})
}
