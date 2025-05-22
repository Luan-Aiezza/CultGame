import SwiftUI
import SpriteKit
import AVFoundation

struct GameStatusView: View {
    @StateObject var timerManager = GameTimerManager()
    @EnvironmentObject var multiplayerManager : MultiplayerManager
    var Audio = AudioManager.shared //Background Music
    
    var body: some View {
        ZStack {
            // VIEW DO MAPA
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
            
            
            //A PARTIR DAQUI SERÁ UI
            
            Text("Tempo restante: \(timerManager.timeRemaining)")
                .foregroundColor(.yellow)
                .font(.title)

            
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
        .onAppear{
            Audio.playBackgroundMusic(named: "OST")
            timerManager.start(duration: 20)
        }
            .padding()
        }
    }

