import SwiftUI
import SpriteKit

struct HomeScreenView: View {
    @EnvironmentObject var vm: GameViewModel

    enum FocusedButton: Hashable {
        case pair
        case howToPlay
    }

    @FocusState private var focusedButton: FocusedButton?

    var isPortuguese: Bool {
        Locale.current.language.languageCode?.identifier == "pt"
    }

    var body: some View {
        NavigationView {
            ZStack {
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

                    NavigationLink(destination: GameView().environmentObject(vm)) {
                        Image(getImageName(button: .pair))
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .pair)

                    NavigationLink(destination: HowToPlayView1().environmentObject(vm)) {
                        Image(getImageName(button: .howToPlay))
                            .resizable()
                            .frame(width: 400, height: 100)
                    }
                    .buttonStyle(.borderless)
                    .focused($focusedButton, equals: .howToPlay)
                }
            }
        }
        .onAppear {
            AudioManager.shared.playBackgroundMusic(named: "Intro_Game_OST")
        }
    }

    func getImageName(button: FocusedButton) -> String {
        let focused = (focusedButton == button)
        let lang = isPortuguese ? "port" : "ing"

        switch button {
        case .pair:
            return focused ? "b_jogar_\(lang)_on" : "b_jogar_\(lang)_off"
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
        isPortuguese
            ? ["manual_port_01", "manual_port_02", "manual_port_03"]
            : ["manual_ing_01", "manual_ing_02", "manual_ing_03"]
    }

    @State private var currentIndex: Int = 0
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 600
                )
                .ignoresSafeArea()

                Image(imageNames[currentIndex])
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: HomeScreenView().environmentObject(vm)) {
                            Image("back")
                                .resizable()
                                .frame(width: 88, height: 60)
                        }
                        .buttonStyle(.borderless)
                    }
                    Spacer()
                }

                HStack {
                    Button(action: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }) {
                        Image("left")
                            .opacity(currentIndex > 0 ? 1 : 0.3)
                    }
                    .buttonStyle(.borderless)
                    .disabled(currentIndex == 0)

                    Spacer()

                    Button(action: {
                        if currentIndex < imageNames.count - 1 {
                            currentIndex += 1
                        }
                    }) {
                        Image("right")
                            .opacity(currentIndex < imageNames.count - 1 ? 1 : 0.3)
                    }
                    .buttonStyle(.borderless)
                    .disabled(currentIndex == imageNames.count - 1)
                }
                .padding(.horizontal)
            }
        }
    }
}


// MARK: - Preview
#Preview {
    HowToPlayView1()
}
