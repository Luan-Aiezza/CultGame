import SwiftUI
import SpriteKit
import AVFoundation

struct DiscussionView: View {
    @StateObject var timerManager = GameTimerManager()
    @EnvironmentObject var multiplayerManager: MultiplayerManager
    @State private var showResultView = false
    let Audio = AudioManager.shared

    var body: some View {
        ZStack {
            if showResultView {
                ResultView()
            } else {
                VStack {
                    Text("Tempo restante: \(timerManager.timeRemaining)")
                        .foregroundColor(.yellow)
                        .font(.title)

                    Text("Discussion")
                }
                .onAppear {
                    Audio.playBackgroundMusic(named: "OST")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        withAnimation {
                            showResultView = true
                        }
                    }
                }
                .padding()
            }
        }
    }
}
