import SwiftUI
import MultipeerConnectivity
import SpriteKit

struct HomeScreenView: View {
    @EnvironmentObject var vm: GameViewModel
    
    enum FocusedButton: Hashable {
        case pair
        case howToPlay
    }

    @FocusState private var focusedButton: FocusedButton?
    @EnvironmentObject var vm: GameViewModel
    
    // Detecta idioma do sistema
    var isPortuguese: Bool {
        Locale.current.language.languageCode?.identifier == "pt"
    }

    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                // Camada de gradiente radial para escurecer a tela
                RadialGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 800
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Image("Logo_1")
                        .resizable()
                        .frame(width: 1203, height: 233)
                    Spacer()

                    // Botão "Parear"
                    NavigationLink(destination: GameView().environmentObject(vm)) {
                        Image(getImageName(button: .pair))
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .pair)

                    // Botão "Como Jogar"
                    NavigationLink(destination: HowToPlayView1().environmentObject(vm)) {
                        Image(getImageName(button: .howToPlay))
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .howToPlay)
                }
            }
        }.onAppear {
            AudioManager.shared.playBackgroundMusic(named: "Intro_Game_OST")
        }
    }

    // MARK: - Nome da imagem com base no foco e idioma
    func getImageName(button: FocusedButton) -> String {
        let focused = (focusedButton == button)
        let lang = isPortuguese ? "port" : "ing"

        switch button {
        case .pair:
            return focused ? "b_parear_\(lang)_on" : "b_parear_\(lang)_off"
        case .howToPlay:
            return focused ? "b_como_jogar_\(lang)_on" : "b_como_jogar_\(lang)_off"
        }
    }
}
struct HowToPlayView1: View {
    var isPortuguese: Bool {
        Locale.current.language.languageCode?.identifier == "pt"
    }

    var imageNames: [String] {
        isPortuguese ?
            ["manual_port_01", "manual_port_02", "manual_port_03"] :
            ["manual_ing_01", "manual_ing_02", "manual_ing_03"]
    }

    @State private var currentIndex: Int = 0
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()

                // Imagem do manual no centro
                Image(imageNames[currentIndex])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: HomeScreenView().environmentObject(vm)) {
                            Image("back")
                                .resizable()
                                .frame(width: 88, height: 60)
                        }.buttonStyle(.borderless)
                    }
                    Spacer()
                }


                // Botões de navegação esquerda e direita
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Image("left")
                            .opacity(currentIndex > 0 ? 1 : 0.3)
                    }.buttonStyle(.borderless)
                    .disabled(currentIndex == 0)
                    Spacer()

                    Button(action: {
                        if currentIndex < imageNames.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Image("right")
                            .opacity(currentIndex < imageNames.count - 1 ? 1 : 0.3)
                    }.buttonStyle(.borderless)
                    .disabled(currentIndex == imageNames.count - 1)
                }
                .padding(.horizontal)
            }
            //.navigationTitle("Como Jogar")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Preview
#Preview {
    HowToPlayView1()
}
