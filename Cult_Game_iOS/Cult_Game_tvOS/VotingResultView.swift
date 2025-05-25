import SwiftUI
import SpriteKit
import AVFoundation

struct VotingResultView: View {
    @StateObject var timerManager = GameTimerManager()
    @EnvironmentObject var multiplayerManager : MultiplayerManager
    @EnvironmentObject var gameViewModel : GameViewModel
    var Audio = AudioManager.shared
    
    var body: some View {
        ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea(.all)
            
            LinearGradient(colors: [Color.black.opacity(0.5), Color.clear], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                if gameViewModel.isTie {
                    Text("Empate!")
                        .font(.custom("VinerHandITC", size: 60))
                        .foregroundStyle(Color.title)
                    Text("Há olhares desconfiados e o culto se contorce sob o peso da suspeita ")
                        .font(.custom("Almendra-Regular", size: 30))
                        .frame(width: UIScreen.main.bounds.width/3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.subtitleResult)
                }
                
                else {
                    if let killedName = multiplayerManager.voted?.character?.displayName {
                        Text("\(killedName) foi eliminado!")
                            .font(.custom("VinerHandITC", size: 60))
                            .foregroundStyle(Color.title)
                        Text("A chama daquela alma se apagou. Mas o verdadeiro profanador ainda respira entre os fiéis.")
                            .font(.custom("Almendra-Regular", size: 30))
                            .frame(width: UIScreen.main.bounds.width/3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.subtitleResult)
                        
                        Image(killedName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(15))
                            .opacity(0.5)
                            .padding(.top, 230)
                    }
                    else {
                        Text("Ninguém foi eliminado")
                            .font(.custom("VinerHandITC", size: 60))
                            .foregroundStyle(Color.title)
                        Text("As línguas se calaram diante do julgamento")
                            .font(.custom("Almendra-Regular", size: 30))
                            .frame(width: UIScreen.main.bounds.width/3)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.subtitleResult)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 200)
            

        }
        .onAppear{
            Audio.playBackgroundMusic(named: "OST")
            timerManager.start(duration: 20)
        }
            .padding()
        }
    }

#Preview {
    VotingResultView(timerManager: GameTimerManager())
        .environmentObject(MultiplayerManager.shared)
        .environmentObject(GameViewModel())
}
