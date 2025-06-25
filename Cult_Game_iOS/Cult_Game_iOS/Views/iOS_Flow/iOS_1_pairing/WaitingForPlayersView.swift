import SwiftUI
import MultipeerConnectivity


// MARK: - Tela principal de espera
struct WaitingForPlayersView: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Image("background_002")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.5))
            
            VStack {
                Spacer()

                Text(viewModel.player.character!.displayName)
                    .font(Font.custom("Almendra-Regular", size: 38))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .padding(.bottom, 16)

                ZStack {
                    Image("PlayerCardBackground")
                        .resizable()
                        .frame(width: 200, height: 200)

                    Image(viewModel.player.character!.displayName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 185)
                        .offset(x: 0, y: 5)
                }

                Spacer()

                Text("Waiting for Players...")
                    .font(Font.custom("Almendra-Regular", size: 18))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .padding(.bottom, 24)

                
                if let character = viewModel.player.character {
                    
                    Text(character.displayName.uppercased())
                        .font(Font.custom("Almendra-Regular", size: 38))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .padding(.bottom, 16)
                    
                    ZStack {
                        Image("PlayerCardBackground")
                            .resizable()
                            .frame(width: 200, height: 200)
                        
                        Image(character.displayName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        
                        
                        Spacer()
                        
                        Text("Waiting for Players...")
                            .font(Font.custom("Almendra-Regular", size: 18))
                            .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                            .padding(.bottom, 50)
                    }
                    .padding(.horizontal)
                    
                }
                else {
                    Text("No player...")
                        .zIndex(6)
                }
            }
        }
    }
}
//
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
//

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


//
//#Preview {
//    let vm = GameViewModel.previewModel()
//    vm.multiplayerManager.isHosting = true
//    return WaitingForPlayersView(viewModel: vm)
//}
