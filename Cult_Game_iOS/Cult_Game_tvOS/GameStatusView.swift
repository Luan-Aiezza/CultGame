import SwiftUI

struct GameStatusView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("Status do Jogo")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 10) {
                Text("Pontos de Fé (Cultistas): \(multiplayerManager.globalState.sharedFaithPoints)")
                    .foregroundColor(.green)
                    .font(.title2)

                ForEach(multiplayerManager.globalState.heresyPoints.sorted(by: { $0.key < $1.key }), id: \.key) { peerName, heresy in
                    HStack {
                        Text("Herege: \(peerName.prefix(10))")
                        Spacer()
                        Text("Heresia: \(heresy)")
                    }
                    .foregroundColor(.red)
                    .font(.title3)
                }

                Text("Seguidores: \(multiplayerManager.globalState.followers)")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .padding()

        }
        .padding()
    }
}
