import SwiftUI
import SpriteKit
import AVFoundation

struct ResultView: View {
    @StateObject var timerManager = GameTimerManager()
    @EnvironmentObject var multiplayerManager : MultiplayerManager
    var Audio = AudioManager.shared //Background Music
    
    var body: some View {
        ZStack {
            VStack {
                Text("Tempo restante: \(timerManager.timeRemaining)")
                    .foregroundColor(.yellow)
                    .font(.title)
                
                Text("Result")
                
                Text("Fé: \(multiplayerManager.globalState.sharedFaithPoints)")
                Text("Seguidores: \(multiplayerManager.globalState.followers)")
                
                Text("Heresia: \(multiplayerManager.globalState.heresyPoints)")
            }

        }
        .onAppear{
            Audio.playBackgroundMusic(named: "OST")
            timerManager.start(duration: 20)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                multiplayerManager.applyPendingEffects()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                multiplayerManager.sendGamePhase(.elimination)
            }
            
        }
            .padding()
        }
    }

