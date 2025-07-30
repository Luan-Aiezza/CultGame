import SwiftUI
import SpriteKit
import AVFoundation

struct DiscussionView: View {
    enum ViewPhase {
        case transition
        case result
        case main
    }
    @EnvironmentObject var gameViewModel: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var viewPhase: ViewPhase = .transition
    let Audio = AudioManager.shared
    var tvResponse = 1.5

    var body: some View {
        ZStack {
            switch viewPhase {
            case .transition:
                TvTransitionTextsView(type: .middleSequence, isFirstRound: true)

            case .result:
                ResultView()
                    .background(Color.clear)
                

            case .main:
                ZStack {
                    VStack {
                        // TIMER CENTRAL SUPERIOR
                        HStack {
                            Spacer()
                            ZStack(alignment: .center) {
                                TimerView(timerManager: gameViewModel.timerManager)
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
                            }.padding(.leading, 80 * tvResponse)

                            Spacer()

                            // BARRAS DE STATUS - CANTO INFERIOR DIREITO
                            VStack(spacing: 12) {
                                StatusBarView()
                            }
                            .padding(.trailing, 80 * tvResponse)
                            .frame(width: 365 * tvResponse)
                        }
                        .padding()
                    }
                }
                .onAppear {
                    gameViewModel.globalState.heresyPoints += 5
                    
                    print("Atualizacao na game view model: \(gameViewModel.globalState.heresyPoints)")
                    
                    if gameViewModel.globalState.heresyPoints > 20 {
                        gameViewModel.globalState.heresyPoints = 20
                    }
                    gameViewModel.timerManager.start(duration: 20)//120
                }
            }
        }
        .onAppear {
            print("estou no discussion view")
            Audio.playBackgroundMusic(named: "Background_Elimination")

            // 1. Exibir TvTransitionTextsView por 5 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                withAnimation {
                    viewPhase = .result
                }

                // 2. Após mais 10 segundos, mostrar conteúdo principal
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    withAnimation {
                        viewPhase = .main
                    }
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

#Preview {
    DiscussionView()
        .environmentObject(MultiplayerManager.shared)
}
