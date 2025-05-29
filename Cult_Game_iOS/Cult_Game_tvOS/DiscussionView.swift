import SwiftUI
import SpriteKit
import AVFoundation

struct DiscussionView: View {
    @ObservedObject var timerManager = GameTimerManager()
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var showResultView = true
    let Audio = AudioManager.shared
    var tvResponse = 1.5

    var body: some View {
        ZStack {
            
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
            
            if showResultView {
                ResultView()
                    .background(Color.clear)
            } else {
                ZStack {
                    // UI sobreposta
                    VStack {
                        
                        // TIMER CENTRAL SUPERIOR
                        HStack {
                            Spacer()
                            ZStack(alignment: .center) {
                                TimerView(timerManager: timerManager)
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
            }
        }
        .onAppear {
            
            print("estou no discussion view")
            timerManager.start(duration: 180)
            Audio.playBackgroundMusic(named: "Background_Elimination")
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                withAnimation {
                    showResultView = false
                }
            }
        }
    }
    
    var playerIconsView: some View {
        HStack(spacing: 8) {
            ForEach(multiplayerManager.connectedPeers, id: \.self) { peer in
                Image("FoxIcon")//trocar pelo icone do jogador
                    .resizable()
                    .frame(width: 36*tvResponse, height: 36*tvResponse)
            }
        }
        .background(Color(red: 0.16, green: 0.15, blue: 0.13))
        .cornerRadius(16)
    }
}


#Preview {
    DiscussionView()
        .environmentObject(MultiplayerManager.shared)
}
