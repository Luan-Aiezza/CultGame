
import SwiftUI

struct HostGameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Text("Faith Points (Shared)")
                .font(.title)
            Text("\(multiplayerManager.globalState.sharedFaithPoints)")
                .font(.largeTitle)

            Text("Followers")
                .font(.title)
            Text("\(multiplayerManager.globalState.followers)")
                .font(.largeTitle)

            Text("Heresy Points (per player)")
                .font(.title2)

            ForEach(multiplayerManager.globalState.heresyPoints.sorted(by: { $0.key < $1.key }), id: \.key) { playerID, heresy in
                Text("\(playerID.prefix(5))...: \(heresy)")
            }
        }
        .padding()
        .onAppear {
            multiplayerManager.authenticatePlayer()

            multiplayerManager.startHosting()
        }
    }
}
#Preview {
    HostGameView()
}
