import SwiftUI
import MultipeerConnectivity

struct MurderView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0

    #warning("Fere o princípio de responsabilidade única. Deveria estar em uma ViewModel, por exemplo.")
    var myCharacter: Character? {
        let myDisplayName = vm.multiplayerManager.myPeerID.displayName
        let character = vm.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
        return character
    }

    #warning("Magic Numbers :( / Essa estrutura é utilizada em EliminationView também, então já que não é específico dessa view, poderia criar uma struct 'LayoutConstants' algo assim, para evitar repetições em mais de um arquivo.")
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

                #warning("1. Prefira utilizar nomes que representam do que se trata a imagem. / 2. Use o ImageResource, chance zero de errar nome da imagem. Ex: Image(.background002)")

                Image(.background002)
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()

                VStack {
                    Spacer()

                #warning("Utilizar fontes customizadas assim, não permite adaptação no Dynamic Type. Sugestão: .font(.custom('', size: 34, relativeTo: .largeTitle))")
                    
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
                            PlayerCellView(
                                player: player,
                                isSelected: selectedPlayerID == peerID,
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
                                width: cardWidth,
                                height: cardHeight
                            )
                        }
                    }
                    .padding(.top, 20)

                #warning("Magic Numbers :(")
                    Spacer(minLength: 520)
                }
                .padding(.horizontal, horizontalPadding)

                // Botão
                Button(action: {
                    #warning("Prefira usar if let/guard let e tratar casos de erro.")
                    if (selectedPlayerID != nil) {
                        voteConfirmed = true
                        if let peer = selectedPlayerID {
                            vm.kill(peer: peer)
                            print("assassinou fulano")
                        }
                        #warning("Lembrar de retirar os prints. Eles não devem ir para a produção.")
                        DispatchQueue.main.async {
                            print(vm.multiplayerManager.players)
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

#Preview {
    MurderView()
}
