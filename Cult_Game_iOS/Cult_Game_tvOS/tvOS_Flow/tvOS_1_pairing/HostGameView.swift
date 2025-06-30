import SwiftUI
import MultipeerConnectivity
import SpriteKit

// MARK: - Host Game View
import SwiftUI
import SpriteKit

struct blockMessageView : View {
    
    @Binding var show : String
    
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
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var canPlay = false
    @State private var errorMessage: String?
    @State var showBlockMessage = false
    @State var stringShow = "Minimum of 5 players"
    
    private let horizontalPadding: CGFloat = 180
    private let horizontalSpacing: CGFloat = 90
    private let verticalSpacing: CGFloat = 40
    private let cardHeight: CGFloat = 120
    private let maxPlayersPerRow = 4
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width - (horizontalPadding * 2) - (horizontalSpacing * CGFloat(maxPlayersPerRow - 1))
            let cardWidth = availableWidth / CGFloat(maxPlayersPerRow)
            
            let players = multiplayerManager.players.filter { (peerID, player) in
                let isNotTV = !peerID.contains("TV")
                let isActive = player.state == .active
                return isNotTV && isActive
            }
            let playerList = Array(players.values)
            
            let firstRow = Array(playerList.prefix(maxPlayersPerRow))
            let secondRow = Array(playerList.dropFirst(maxPlayersPerRow))
            
            ZStack() {
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
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
                                .frame(height: 95) // altura fixa, mas largura flexível
                        }
                    }
                    .frame(maxWidth: 500) // limite razoável para a largura
                    .buttonStyle(.borderless)
                    .padding(.bottom, 64)
                    
                    
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                    }
                    
                }
                
                VStack(spacing: verticalSpacing) {
                    HStack(spacing: horizontalSpacing) {
                        ForEach(firstRow, id: \.id) { player in
                            PlayerCardView(
                                player: player,
                                width: cardWidth,
                                height: cardHeight
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    if !secondRow.isEmpty {
                        HStack(spacing: horizontalSpacing) {
                            ForEach(secondRow, id: \.id) { player in
                                PlayerCardView(
                                    player: player,
                                    width: cardWidth,
                                    height: cardHeight
                                )
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }

                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if showBlockMessage {
                            blockMessageView(show: $stringShow)
                                .zIndex(4)
                                .padding(.trailing, -60)
                                .padding(.bottom, 50)
                        }
                    }
                    
                }
            }
            .onChange(of: multiplayerManager.players.count) { count in
                canPlay = count >= 0
            }
            .onAppear {
                MainScene.shared?.zoomOut()
                multiplayerManager.startHosting()
            }
            
            HStack (spacing: 16) {
                Spacer()
                Image("minionsImage")
                    .resizable()
                    .frame(width: 76, height: 74)
                    .padding(.bottom)
                Text("\(playerList.count)/7")
                    .font(Font.custom("VinerHandITC", size: 60))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
            }.padding(.top, 900)
        }
    }
    
    func startGame() {
        if multiplayerManager.connectedPeers.count < 1 || multiplayerManager.connectedPeers.count > 7 {
            showBlockMessage = true
            return
        }
        
        assignRoles()
        gameStarted = true
        errorMessage = nil
        viewModel.advancePhaseAfterTimer()
        print(multiplayerManager.currentPhase)
    }
    
    func assignRoles() {
        var players = multiplayerManager.connectedPeers.shuffled()
        
        guard let heretic = players.popLast() else {
            errorMessage = "Error assigning heretic role!"
            return
        }
        
        var roles: [MCPeerID: PlayerRole] = [heretic: .heretic]
        for peer in players {
            roles[peer] = .cultist
        }
        
        self.playerRoles = roles.mapKeys(\.displayName)
        
        for (peer, role) in roles {
            multiplayerManager.sendRole(role, to: peer)
        }
    }
}

// MARK: - Preview
#Preview {
    HostGameView()
}
