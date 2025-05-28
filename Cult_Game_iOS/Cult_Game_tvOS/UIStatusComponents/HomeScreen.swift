//import SwiftUI
//import MultipeerConnectivity
//import SpriteKit
//
//
//// MARK: - Home Screen
//struct HomeScreenView: View {
//    var body: some View {
//        NavigationView {
//            ZStack {
//                SpriteView(scene: scene)
//                    .ignoresSafeArea()
//                
//                // Camada de gradiente radial para escurecer a tela
//                RadialGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
//                    center: .center,
//                    startRadius: 10,
//                    endRadius: 800
//                )
//                .ignoresSafeArea()
//                
//                VStack() {
//                    Image("Logo_1")
//                        .resizable()
//                        .frame(width: 1206, height: 233)
//                    
//                    Spacer()
//                    
//                    NavigationLink(destination: HostGameView()) {
//                        Image("pairButton")
//                            //.resizable()
//                            .frame(width: 100, height: 100)
//
//                    }.buttonStyle(.borderless)
//                    
////                    NavigationLink(destination: HowToPlayView()) {
////                            Image("howToPlayButton")
////                                //.resizable()
////                                .frame(width: 100, height: 100)
////
////                    }.buttonStyle(.borderless)
//                }.padding(.top, 159)
//            }
//        }
//    }
//}
//// MARK: - Preview
//#Preview {
//    HomeScreenView()
//}
import SwiftUI
import MultipeerConnectivity
import SpriteKit

struct HomeScreenView: View {
    enum FocusedButton: Hashable {
        case pair
        case howToPlay//aqui
    }

    @FocusState private var focusedButton: FocusedButton?
    
    // Detecta idioma do sistema
    var isPortuguese: Bool {
        Locale.current.language.languageCode?.identifier == "pt"
    }

    var body: some View {
        NavigationView {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Text("logo")
                        .font(Font.custom("VinerHandITC", size: 50))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))

                    // Botão "Parear"
                    NavigationLink(destination: HostGameView()) {
                        Image(getImageName(button: .pair))
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .pair)
                    // Botão "Como Jogar"
                    NavigationLink(destination: HowToPlayView1()) {//aqui
                        Image(getImageName(button: .howToPlay))//aqui
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .howToPlay)//aqui
                }
            }
        }.onAppear{
            AudioManager.shared.playBackgroundMusic(named: "Intro_Game_OST")

        }
        .onDisappear{
            AudioManager.shared.stopBackgroundMusic()
        }
    }

    // MARK: - Nome da imagem com base no foco e idioma
    func getImageName(button: FocusedButton) -> String {
        let focused = (focusedButton == button)
        let lang = isPortuguese ? "port" : "ing"

        switch button {
        case .pair:
            return focused ? "b_parear_\(lang)_on" : "b_parear_\(lang)_off"
        case .howToPlay://aqui
            return focused ? "b_como_jogar_\(lang)_on" : "b_como_jogar_\(lang)_off"
        }
    }
}

// MARK: - tutorial na tv de como jogar

struct HowToPlayView1: View {//aqui
    @State private var currentIndex = 0
    let imageNamesIngles = ["onborarding/tutorial_ing_01", "onborarding/tutorial_ing_02", "onborarding/tutorial_ing_03"]
    let imageNamesPortugues = ["onborarding/tutorial_port_01", "onborarding/tutorial_port_02", "onborarding/tutorial_port_03"]
//localized portugues e ingles
    var imageNames: [String] {
        print("System language: \(Locale.current.language.languageCode?.identifier ?? "unknown")")

            if Locale.current.language.languageCode?.identifier == "pt" {
                return imageNamesPortugues
            } else {
                return imageNamesIngles
            }
        }
    
    var body: some View {
        ZStack{
            SpriteView(scene: scene)
                .ignoresSafeArea()
//imagem do tutorial
            VStack {

                if let uiImage = UIImage(named: imageNames[currentIndex]) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else {
                    Text("Image not found: \(imageNames[currentIndex])")
                        .foregroundColor(.red)
                        .padding()
                }
//botao direita e esquerda
                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Image("left")
                            .padding()
                    }.buttonStyle(.borderless)
                    .disabled(currentIndex == 0)
                    Spacer()
                    
                    Button(action: {
                        if currentIndex < imageNames.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Image("right")
                            .padding()
                    }.buttonStyle(.borderless)
                    .disabled(currentIndex == imageNames.count - 1)
                }
                .padding(.horizontal, 50)
            }
            //.navigationTitle("Como Jogar")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - Preview
#Preview {
    HomeScreenView()
}
