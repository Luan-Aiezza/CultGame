import SwiftUI
import MultipeerConnectivity


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


// MARK: - Tela principal de espera
struct WaitingForPlayersView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Image("BackgroundWaitingForPlayers")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.5))

            VStack {
                Spacer()

                Text(viewModel.player.character.displayName)
                    .font(Font.custom("Almendra-Regular", size: 38))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .padding(.bottom, 16)

                ZStack {
                    Image("PlayerCardBackground")
                        .resizable()
                        .frame(width: 200, height: 200)

                    Image(viewModel.player.character.displayName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 185)
                        .offset(x: 0, y: 5)
                }

                Spacer()

                Text("Waiting for Players...")
                    .font(Font.custom("Almendra-Regular", size: 18))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .padding(.bottom, 90)
            }
            .padding(.horizontal)
        }
    }
}

//extension GameViewModel {
//    static func previewModel() -> GameViewModel {
//        let vm = GameViewModel()
//        let peer = MCPeerID(displayName: "You")
//        vm.multiplayerManager._setFakePeerID(peer)
//        vm.multiplayerManager.connectedPeers = [peer]
//
//        vm.assignCharacter(.bunny)
//        return vm
//    }
//}




#Preview {
    //WaitingForPlayersView(viewModel: GameViewModel.previewModel())
}

