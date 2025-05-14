import SwiftUI
import MultipeerConnectivity

// MARK: - Modelo do jogador para a UI
struct Player: Identifiable, Hashable {
    let id = UUID()
    let peerID: MCPeerID
    let isYou: Bool
    let character: Character

    var name: String {
        character.displayName
    }

    var iconName: String {
        character.displayName
    }

}

// MARK: - Extensão para nome legível do personagem
extension Character {
    var displayName: String {
        switch self {
        case .fox: return "Fox"
        case .panda: return "Panda"
        case .bunny: return "Bunny"
        case .tiger: return "Tiger"
        case .deer: return "Deer"
        case .pig: return "Pig"
        case .wolf: return "Wolf"
        }
    }
}


// MARK: - Tela principal
struct WaitingForPlayersView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Image("background_001")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .overlay {
                    
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                }

            VStack(spacing: 20) {
                Spacer().frame(height: 40)

                Text("Waiting\nfor Players")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("VinerHandITC", size: 34))
                    .foregroundColor(Color.title)
                    .padding(.top, 40)

                PlayersGrid(players: viewModel.playersForDisplay)

                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Grade dos jogadores
struct PlayersGrid: View {
    let players: [Player]

    var body: some View {
        VStack(spacing: 15) {
            ForEach(players.chunked(into: 2), id: \.self) { row in
                HStack(spacing: 15) {
                    if row.count == 2 {
                        PlayerCard(player: row[0])
                        PlayerCard(player: row[1])
                    } else {
                        Spacer()
                        PlayerCard(player: row[0])
                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Cartão do jogador com imagens
struct PlayerCard: View {
    let player: Player

    var body: some View {
        ZStack {
            Image("PlayerCardBackground")
                .resizable()
                .scaledToFit()
                .frame(width: 161, height: 68)

            HStack(spacing: 8) {
                Image(player.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 50)
                    //.padding(.trailing)

                VStack(spacing: 2) {
                    Text(player.name)
                        .font(Font.custom("Almendra-Regular", size: 19))
                        .font(.headline)
                        .foregroundColor(.white)
                        //.padding(.trailing)

                    if player.isYou {
                        ZStack {
                            Image("YouBackground")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 15)
                            Text("You")
                                .font(Font.custom("Almendra-Regular", size: 13))
                                //.font(.caption2)
                                .foregroundColor(.orange)
                                
                        }
                    }
                }.padding(.trailing)
            }
            .padding(.trailing)
        }
        .frame(width: 150, height: 90)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}



//extension GameViewModel {
//    static func previewModel() -> GameViewModel {
//        let vm = GameViewModel()
//
//        // Fake peer que será considerado como o jogador local
//        let myFakePeer = MCPeerID(displayName: "You")
//
//        // Lista de peers simulados
//        let fakePeers: [MCPeerID] = [
//            MCPeerID(displayName: "Jogador 1"),
//            MCPeerID(displayName: "Jogador 2"),
//            myFakePeer
//        ]
//
//        let characters: [Character] = [.fox, .panda, .tiger]
//
//        // Atribui os personagens
//        for (peer, character) in zip(fakePeers, characters) {
//            vm.assignedCharacters[peer] = character
//        }
//
//        // Injeta os peers simulados diretamente no MultiplayerManager
//        vm.multiplayerManager.connectedPeers = fakePeers
//
//        // ⚠️ Apenas para Preview: define o peer local como o "You"
//        vm.multiplayerManager._setFakePeerID(myFakePeer)
//
//        return vm
//    }
//}


extension GameViewModel {
    static func previewModel() -> GameViewModel {
        let vm = GameViewModel()

        // Apenas o próprio jogador
        let myFakePeer = MCPeerID(displayName: "You")

        vm.assignedCharacters[myFakePeer] = .fox
        vm.multiplayerManager.connectedPeers = [myFakePeer]
        vm.multiplayerManager._setFakePeerID(myFakePeer)

        return vm
    }
}



#Preview {
    WaitingForPlayersView(viewModel: GameViewModel.previewModel())
}
