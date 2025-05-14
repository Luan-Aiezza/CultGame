import SwiftUI
import SpriteKit

struct GameStatusView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared

    // Função que retorna a cena
    var backgroundScene: SKScene {
        let scene = GameBackgroundScene()
        scene.size = CGSize(width: 400, height: 800) // Ajuste conforme necessário
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        ZStack {
            // Tile Map ao fundo
            SpriteView(scene: backgroundScene)
                .ignoresSafeArea()

            // Conteúdo principal
            VStack(spacing: 20) {
                Text("Game Status")
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 10) {
                    Text("Faith points: \(multiplayerManager.globalState.sharedFaithPoints)")
                        .foregroundColor(.green)
                        .font(.title2)

                    ForEach(multiplayerManager.globalState.heresyPoints.sorted(by: { $0.key < $1.key }), id: \.key) { peerName, heresy in
                        HStack {
                            Text("Heretic: \(peerName.prefix(10))")
                            Spacer()
                            Text("Heresy: \(heresy)")
                        }
                        .foregroundColor(.red)
                        .font(.title3)
                    }

                    Text("Followers: \(multiplayerManager.globalState.followers)")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .padding()
            }
            .padding()
        }
    }
}
