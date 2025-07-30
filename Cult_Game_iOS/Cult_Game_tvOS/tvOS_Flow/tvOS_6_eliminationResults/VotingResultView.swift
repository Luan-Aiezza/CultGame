import SwiftUI
import SpriteKit
import AVFoundation

struct VotingResultView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var gameViewModel: GameViewModel
    var Audio = AudioManager.shared
    
    var body: some View {
        ZStack {
            // Dark gradient overlay
            LinearGradient(colors: [Color.black.opacity(1), Color.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                // Caso de empate
                if gameViewModel.isTie {
                    Text("Draw!")
                        .font(.custom("VinerHandITC", size: 70))
                        .foregroundStyle(Color.title)

                    Text("There are suspicious looks and the cult writhes under the weight of suspicion")
                        .font(.custom("Almendra-Regular", size: 36))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)
                }

                // Caso de jogador eliminado por votos, somente se eliminado e jogador presente
                else if let eliminated = gameViewModel.eliminatedPlayer,
                        let killedName = multiplayerManager.players[eliminated]?.character?.displayName {

                    Text("\(killedName) has been eliminated!")
                        .font(.custom("VinerHandITC", size: 70))
                        .foregroundStyle(Color.title)

                    Text("The flame of that soul has gone out. But the true defiler still breathes among the faithful.")
                        .font(.custom("Almendra-Regular", size: 36))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)

                    Image("\(killedName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 151, height: 161)
                        .rotationEffect(.degrees(15))
                        .opacity(0.5)
                        .padding(.top, 430)
                        .position(x: 960, y: -550)
                }

                // Caso de ninguém eliminado (eliminatedPlayer é nil ou jogador não está presente)
                else {
                    Text("No one was voted!")
                        .font(.custom("VinerHandITC", size: 70))
                        .foregroundStyle(Color.title)

                    Text("The cult fell silent...")
                        .font(.custom("Almendra-Regular", size: 36))
                        .frame(width: UIScreen.main.bounds.width / 3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)
                    Spacer()
                }
            }
            .padding(.vertical, 100)
        }
        .onAppear {
            MainScene.shared?.zoomIn()
            gameViewModel.evaluateVotes()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
                gameViewModel.advancePhaseAfterTimer()
            })
            
            gameViewModel.timerManager.start(duration: 10)
            Audio.setVolume(to: 0.4)
            Audio.playSound(named: "BonfireRise")
        }
        .padding()
    }
}
