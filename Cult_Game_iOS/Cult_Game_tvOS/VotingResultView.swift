import SwiftUI
import SpriteKit
import AVFoundation

struct VotingResultView: View {
    var timerManager = GameTimerManager()
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var gameViewModel: GameViewModel
    var Audio = AudioManager.shared
    
    var body: some View {
        ZStack {
            // Background scene
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)

            // Dark gradient overlay
            LinearGradient(colors: [Color.black.opacity(0.5), Color.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // Caso de empate
                if multiplayerManager.voted == nil {
                    Text("Empate!")
                        .font(.custom("VinerHandITC", size: 60))
                        .foregroundStyle(Color.title)

                    Text("Há olhares desconfiados e o culto se contorce sob o peso da suspeita")
                        .font(.custom("Almendra-Regular", size: 30))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)
                }

                // Caso de jogador eliminado
                else if let killedName = multiplayerManager.voted?.character?.displayName {

                    Text("\(killedName) foi eliminado!")
                        .font(.custom("VinerHandITC", size: 60))
                        .foregroundStyle(Color.title)

                    Text("A chama daquela alma se apagou. Mas o verdadeiro profanador ainda respira entre os fiéis.")
                        .font(.custom("Almendra-Regular", size: 30))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)

                    Image("\(killedName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(15))
                        .opacity(0.5)
                        .padding(.top, 230)
                }

                Spacer()
            }
            .padding(.vertical, 200)
        }
        .onAppear {
            gameViewModel.evaluateVotes()
            Audio.playBackgroundMusic(named: "Background_Elimination")
            timerManager.start(duration: 20)
        }
        .padding()
    }
}
