import SwiftUI
import SpriteKit

struct BlockMessageView: View {
    @Binding var show: String

    var body: some View {
        ZStack {
            Image("tip_001")
                .resizable()
                .scaledToFit()
                .frame(width: 260)

            Text(show)
                .frame(width: 240)
                .font(.custom("Almendra-Regular", size: 24))
                .foregroundColor(Color.title)
                .padding(.horizontal, 4)
                .padding(.bottom, 12)
                .multilineTextAlignment(.center)
        }
    }
}



struct HostGameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var multiplayerManager = GameKitMultiplayerManager.shared

    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var canPlay = false
    @State private var errorMessage: String?
    @State private var showMatchmaker = true
    
    // Added state property to hold matchmaker error messages
    @State private var matchmakerErrorMessage: String? = nil
    
    @State private var didStartHosting = false

    @State var showBlockMessage = false
    @State var stringShow = "Minimum of 5 players"

    private let horizontalPadding: CGFloat = 180
    private let horizontalSpacing: CGFloat = 90
    private let verticalSpacing: CGFloat = 40
    private let cardHeight: CGFloat = 120
    private let maxPlayersPerRow = 4
    
    private func playerGrid(playerList: [PlayerModel], cardWidth: CGFloat, geometry: GeometryProxy) -> some View {
        let firstRow = Array(playerList.prefix(maxPlayersPerRow))
        let secondRow = Array(playerList.dropFirst(maxPlayersPerRow))

        return VStack(spacing: verticalSpacing) {
            HStack(spacing: horizontalSpacing) {
                ForEach(firstRow, id: \.id) { player in
                    PlayerCardView(player: player, width: cardWidth, height: cardHeight)
                }
            }

            if !secondRow.isEmpty {
                HStack(spacing: horizontalSpacing) {
                    Spacer(minLength: (geometry.size.width - (cardWidth + horizontalSpacing) * CGFloat(secondRow.count - 1) - cardWidth) / 2)

                    ForEach(secondRow, id: \.id) { player in
                        PlayerCardView(player: player, width: cardWidth, height: cardHeight)
                    }

                    Spacer(minLength: (geometry.size.width - (cardWidth + horizontalSpacing) * CGFloat(secondRow.count - 1) - cardWidth) / 2)
                }
            }
        }
    }
    

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2) - (horizontalSpacing * CGFloat(maxPlayersPerRow - 1))
            let cardWidth = availableWidth / CGFloat(maxPlayersPerRow)

            let players = multiplayerManager.players.filter { (id, player) in
                let isNotTV = !id.contains("TV")
                let isActive = player.state == .active
                return isNotTV && isActive
            }

            let playerList = Array(players.values)
            let firstRow = Array(playerList.prefix(maxPlayersPerRow))
            let secondRow = Array(playerList.dropFirst(maxPlayersPerRow))

            ZStack {
                Color.black.opacity(0.4).ignoresSafeArea()

                VStack {
                    Text("Pairing with players")
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .padding(.top, 48)
                        .font(.custom("VinerHandITC", size: 60))

                    Spacer()

                    Button(action: startGame) {
                        ZStack {
                            Image(canPlay ? "buttonStart" : "disableStart")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 95)
                        }
                    }
                    .frame(maxWidth: 500)
                    .buttonStyle(.borderless)
                    .padding(.bottom, 64)

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                    }
                }

                playerGrid(playerList: playerList, cardWidth: cardWidth, geometry: geometry)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if showBlockMessage {
                            BlockMessageView(show: $stringShow)
                                .zIndex(4)
                                .padding(.trailing, -60)
                                .padding(.bottom, -50)
                        }
                    }

                    HStack(spacing: 16) {
                        Spacer()
                        Image("minionsImage")
                            .resizable()
                            .frame(width: 76, height: 74)
                            .padding(.bottom)
                        Text("\(playerList.count)/7")
                            .font(Font.custom("VinerHandITC", size: 60))
                            .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    }
                }
            }
            .onAppear {
                MainScene.shared?.zoomOut()
                startHostingGame()
            }
        }
    }
    func startHostingGame() {
        GameKitMultiplayerManager.shared.authenticateLocalPlayer { success in
            if success {
                multiplayerManager.startMatchmaking(asHost: true) { error in
                    if let error = error {
                        print("🔍 Erro completo: \(error.localizedDescription), \(String(describing: error))")
                    } else {
                        print("✅ Match iniciado com sucesso")
                    }
                }
            } else {
                print("🚫 Não foi possível autenticar o jogador")
            }
        }
    }

    func startGame() {
        let totalPlayers = multiplayerManager.players.count

        if totalPlayers < 1 || totalPlayers > 7 {
            showBlockMessage = true
            stringShow = "Minimum of 5, maximum of 7 players"
            return
        }

        assignRoles()
        gameStarted = true
        errorMessage = nil
        viewModel.advancePhaseAfterTimer()
    }

    func assignRoles() {
        var playerIDs = multiplayerManager.players.keys.shuffled()

        guard let hereticID = playerIDs.popLast() else {
            errorMessage = "Error assigning heretic role!"
            return
        }

        var roles: [String: PlayerRole] = [hereticID: .heretic]
        for id in playerIDs {
            roles[id] = .cultist
        }

        self.playerRoles = roles

        for (id, role) in roles {
            if let gkPlayer = multiplayerManager.gkPlayers[id] {
                multiplayerManager.sendRole(role, to: gkPlayer)
            }
        }
    }
}

#Preview {
    HostGameView()
}
