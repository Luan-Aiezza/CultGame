import SwiftUI
import SpriteKit
import AVFoundation

struct DiscussionView: View {
    @StateObject var timerManager = GameTimerManager()
    @EnvironmentObject var multiplayerManager : MultiplayerManager
    var Audio = AudioManager.shared //Background Music
    
    var body: some View {
        ZStack {
            VStack {
                Text("Tempo restante: \(timerManager.timeRemaining)")
                    .foregroundColor(.yellow)
                    .font(.title)
                
                Text("Discussion")
            }

        }
        .onAppear{
            Audio.playBackgroundMusic(named: "OST")
            timerManager.start(duration: 20)
        }
            .padding()
        }
    }

