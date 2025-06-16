import SwiftUI
import SpriteKit
import Combine

struct GameStatusView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var timer = GameTimerManager()
    
    var tvResponse = 1.5

    var body: some View {
        
        ZStack {
            // UI sobreposta
            
            VStack {
                
                // TIMER CENTRAL SUPERIOR
                HStack {
                    Spacer()
                    ZStack(alignment: .center) {
                        TimerView(timerManager: timer)
                            .frame(width: 194 * tvResponse, height: 74 * tvResponse)
                            .background(Color(red: 0.16, green: 0.15, blue: 0.13))
                        Image("TimerBar")
                            .resizable()
                            .frame(width: 200 * tvResponse, height: 80 * tvResponse)
                    }
                    Spacer()
                }
                Spacer()

                HStack {
                    // ÍCONES DOS JOGADORES - CANTO INFERIOR ESQUERDO
                    ZStack(alignment: .center) {
                        
                        playerIconsView
                            .frame(width: 388 * tvResponse, height: 60 * tvResponse)
                            .background(Color(red: 0.16, green: 0.15, blue: 0.13))
                            .cornerRadius(16)
                        
                        Image("PlayersBorder")
                            .resizable()
                            .frame(width: 394 * tvResponse, height: 66 * tvResponse)
                        
                    }.padding(.leading, 80*tvResponse)
                    
                    Spacer()

                    // BARRAS DE STATUS - CANTO INFERIOR DIREITO
                    VStack(spacing: 12) {
                        StatusBarView()
                    }
                    .padding(.trailing, 80*tvResponse)
                    .frame(width: 365*tvResponse)
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            MainScene.shared?.zoomOut()
            timer.start(duration: 90) //90
            AudioManager.shared.playBackgroundMusic(named: "Background_Map")
        }
    }
    
    private var playerIconsView: some View {
        HStack(spacing: 8) {
            ForEach(multiplayerManager.players.filter { (key, player) in
                !key.contains("TV") && player.state == .active
            }.map { $0.value }, id: \.id) { player in
                if let displayName = player.character?.displayName, !displayName.isEmpty {
                    Image(displayName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36 * tvResponse, height: 36 * tvResponse)
                        .cornerRadius(10)
                } else {
                    Image("personPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36 * tvResponse, height: 36 * tvResponse)
                        .cornerRadius(10)
                }
            }
        }
        .background(Color(red: 0.16, green: 0.15, blue: 0.13))
        .cornerRadius(16)
    }
    
}
