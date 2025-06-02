import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

struct EliminationResultsView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var viewModel: GameViewModel
    @State var isDisconnected = false

    var isPlayerEliminated: Bool {
        viewModel.eliminatedPlayer == viewModel.peerID
    }



    var eliminatedCharacter: Character? {
        guard let eliminated = viewModel.eliminatedPlayer,
              let player = multiplayerManager.players[eliminated] else {
            return nil
        }
        return player.character
    }

    let cultistGold = Color(red: 1.0, green: 0.91, blue: 0.75)

    var body: some View {
        ZStack {

            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                                multiplayerManager.disconnect()
                                isDisconnected = true
                    }) {
                        Image("exit")
                            .resizable()
                            .frame(width: 48, height: 35)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 17.4)
                }
                .padding(.top, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            VStack(spacing: 30) {
                Spacer()


                if isPlayerEliminated, let character = eliminatedCharacter {
                    Text("You were eliminated!")
                        .font(.custom("VinerHandITC", size: 50))
                        .bold()
                        .foregroundColor(cultistGold)
                        .multilineTextAlignment(.center)
                        .frame(width: 260, alignment: .center)
                        .padding(.horizontal, 24)

                    Text(randomSacrificeDescription())
                        .font(.custom("Almendra", size: 24))
                        .foregroundColor(cultistGold)
                        .multilineTextAlignment(.center)
                        .lineSpacing(0.2)
                        .frame(width: 312, alignment: .center)
                        .padding(.horizontal, 32)

                    DefeatImageView(imageName: "\(character.rawValue.capitalized)C")
                        .scaledToFit()
                        //.frame(width: 150, height: 10)
                        //.offset(x: 29, y: 100)
                        .shadow(radius: 10)

                    Spacer()

                } else {
                    Spacer()
                    Text(" ")
                    Spacer()
                }
            }.navigationDestination(isPresented: $isDisconnected) {
                PlayView()
            }

            .padding()
        }
    }


    func randomSacrificeDescription() -> String {
        [
            "You were sacrificed, yet the traitor still defiles the cult.",
            "You burned for sins that were not yours.",
            "You burned for justice… and were betrayed by your own.",
            "You were silenced by fire — and the lie found its voice.",
            "Judged by faith, condemned by mistake.",
            "Consumed by the cult’s flame, your silence screams injustice."
        ].randomElement()!
    }
}


//exibe a imagem do herege derrotado, escurecendo gradualmente e desaparecendo com fade-out
struct DefeatImageView: View {
    let imageName: String
    
    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: -8, y: -120)
            .frame(width: 115, height: 130)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece imagem
            .opacity(fadeOut) // fade out da imagem
            .onAppear {
                withAnimation(.easeIn(duration: 8)) {
                    darkness = 1.0 // totalmente preto
                }
                withAnimation(.easeOut(duration: 15).delay(2)) {
                    fadeOut = 0.0 // desaparece
                }
            }
    }
}


#if DEBUG
extension GameViewModel {
    static func previewEliminated() -> GameViewModel {
        let vm = GameViewModel()
        let peerID = "JogadorTest"

        // ✅ Define o peer fake no manager
        let testPeer = MCPeerID(displayName: peerID)
        //vm.multiplayerManager.setFakePeerID(testPeer)

        // ✅ Cria e registra o player eliminado
        let player = PlayerModel(
            id: peerID,
            state: .inactive,
            character: .fox
        )
        vm.multiplayerManager.players[peerID] = player
        //vm.multiplayerManager.connectedPeers = [peerID]
        vm.multiplayerManager.connectedPeers = [testPeer]
        vm.eliminatedPlayer = peerID
        vm.voteOccurred = true
        vm.didEvaluate = true

        return vm
    }
}
#endif


func previewEliminated() -> GameViewModel {
    let vm = GameViewModel()
    let peerID = "JogadorTest"

    let testPeer = MCPeerID(displayName: peerID)
    //vm.multiplayerManager.setFakePeerID(testPeer)

    let player = PlayerModel(
        id: peerID,
        state: .inactive,
        character: .fox
    )
    vm.multiplayerManager.players[peerID] = player
    vm.multiplayerManager.connectedPeers = [testPeer]
    vm.eliminatedPlayer = peerID
    vm.voteOccurred = true
    vm.didEvaluate = true

    print("👤 peerID: \(testPeer.displayName)")
    print("🔥 eliminado: \(vm.eliminatedPlayer ?? "nil")")

    return vm
}
