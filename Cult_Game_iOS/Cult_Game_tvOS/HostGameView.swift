
import SwiftUI
import MultipeerConnectivity
import SpriteKit

// MARK: - Host Game View
struct HostGameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var playerRoles: [String: PlayerRole] = [:]
    @State private var gameStarted = false
    @State private var errorMessage: String?
    private let horizontalPadding: CGFloat = 60
    private let horizontalSpacing: CGFloat = 32
    private let verticalSpacing: CGFloat = 40
    private let cardHeight: CGFloat = 120
    private let maxPlayersPerRow = 4
    
    let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)
    
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
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Waiting for Players...")
                        .font(Font.custom("VinerHandITC", size: 30))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    
                    VStack(spacing: verticalSpacing) {
                        HStack(spacing: horizontalSpacing) {
                            ForEach(firstRow, id: \.id) { player in
                                PlayerElimView(
                                    player: player,
                                    isSelected: false,
                                    glowRotation: .constant(0),
                                    onSelect: {}, // sem interação
                                    width: cardWidth,
                                    height: cardHeight
                                )
                            }
                        }
                        
                        if !secondRow.isEmpty {
                            HStack(spacing: horizontalSpacing) {
                                Spacer(minLength: (geometry.size.width - (cardWidth + horizontalSpacing) * CGFloat(secondRow.count - 1) - cardWidth) / 2)
                                ForEach(secondRow, id: \.id) { player in
                                    PlayerElimView(
                                        player: player,
                                        isSelected: false,
                                        glowRotation: .constant(0),
                                        onSelect: {}, // sem interação
                                        width: cardWidth,
                                        height: cardHeight
                                    )
                                }
                                Spacer(minLength: (geometry.size.width - (cardWidth + horizontalSpacing) * CGFloat(secondRow.count - 1) - cardWidth) / 2)
                            }
                        }
                    }
                    
                    //                ScrollView {
                    //                    LazyVGrid(columns: columns, spacing: 20) {
                    //                        ForEach(multiplayerManager.connectedPeers, id: \.self) { peer in
                    //                            VStack {
                    //                                Text(peer.displayName.prefix(10))
                    //                                    .font(.headline)
                    //                                    .foregroundColor(.white)
                    //                                if let role = playerRoles[peer.displayName] {
                    //                                    Text(role == .cultist ? "Cultist" : "Heretic")
                    //                                        .foregroundColor(role == .cultist ? .green : .red)
                    //                                } else {
                    //                                    Text("No role")
                    //                                        .foregroundColor(.gray)
                    //                                }
                    //                                if let character = viewModel.multiplayerManager.players[peer]?.character {
                    //                                    Text( character.displayName)
                    //                                } else {
                    //                                    Text("No character")
                    //                                        .foregroundColor(.gray)
                    //                                }
                    //                            }
                    //                            .frame(maxWidth: .infinity, minHeight: 80)
                    //                            .background(Color.black.opacity(0.5))
                    //                            .cornerRadius(10)
                    //                        }
                    //                    }
                    //                }
                    //                .frame(height: 200)
                    
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button(action: startGame) {
                        Image("buttonStart")
                        //.resizable()
                        //.frame(width: 80, height: 80)
                            .foregroundColor(gameStarted ? .gray : .blue)
                    }.buttonStyle(.borderless)
                        .disabled(gameStarted)
                    
                    Text("Players connected: \(multiplayerManager.connectedPeers.count)")
                        .font(Font.custom("VinerHandITC", size: 30))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    
                    Spacer()
                    
                    if gameStarted {
                        GameStatusView()
                            .transition(.slide)
                        
                        Spacer()
                        
                        timerView
                            .padding(.bottom)
                    }
                }
                .onAppear {
                    multiplayerManager.startHosting()
                }
            }
        }
    }
    func startGame() {
        print(viewModel.multiplayerManager.players)
        if multiplayerManager.connectedPeers.count < 1 || multiplayerManager.connectedPeers.count > 7 {
            errorMessage = "You need to connect between 5 and 7 players"
            return
        }
        
        assignRoles()
        gameStarted = true
        errorMessage = nil
        viewModel.advancePhaseAfterTimer()
        
        print("apertei o botao de start no hosting")
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
    
    private var timerView: some View {
        VStack {
            Text("Phase: \(multiplayerManager.currentPhase)")
            Text("Time left: \(viewModel.timeRemaining)s")
                .font(.headline)
                .padding(8)
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(8)
        }
    }
    
}

// MARK: - Preview
#Preview {
    HostGameView()
}
