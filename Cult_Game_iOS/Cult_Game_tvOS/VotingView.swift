import SwiftUI
import SpriteKit
import Combine

struct VotingView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var timer = GameTimerManager()
    @State private var showStory = true
    
    var tvResponse = 1.5
    
    var body: some View {
        ZStack{
            if showStory {
                TvTransitionTextsView(type: .endSequence, isFirstRound: true)
                    .ignoresSafeArea(.all)
                
            } else {
                ZStack {
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
                        .padding()
                    }
                }
                .onDisappear {
                    AudioManager.shared.stopBackgroundMusic()
                }
                .onAppear {
                    MainScene.shared?.zoomIn()
                    timer.start(duration: 60)//60
                    AudioManager.shared.playBackgroundMusic(named: "Background_Elimination")
                }
            }
        }.onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                withAnimation {
                    showStory = false
                }
            }
        }
    }
    //GENERALIZAR POIS É CHAMADO EM 3 VIEWS
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
