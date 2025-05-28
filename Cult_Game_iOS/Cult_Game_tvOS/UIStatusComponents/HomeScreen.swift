import SwiftUI
import MultipeerConnectivity
import SpriteKit


// MARK: - Home Screen
struct HomeScreenView: View {
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
                
                VStack() {
                    Image("Logo_1")
                        .resizable()
                        .frame(width: 1206, height: 233)
                    
                    Spacer()
                    
                    NavigationLink(destination: GameView()) {
                        Image("pairButton")
                            //.resizable()
                            .frame(width: 100, height: 100)

                    }.buttonStyle(.borderless)
                    
//                    NavigationLink(destination: HowToPlayView()) {
//                            Image("howToPlayButton")
//                                //.resizable()
//                                .frame(width: 100, height: 100)
//
//                    }.buttonStyle(.borderless)
                }.padding(.top, 159)
            }
        }
    }
}
// MARK: - Preview
#Preview {
    HomeScreenView()
}
