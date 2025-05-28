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
                
                VStack(spacing: 40) {
                    Text("logo")
                        .font(Font.custom("VinerHandITC", size: 50))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    
                    NavigationLink(destination: HostGameView()) {
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
                }
            }
        }
    }
}
// MARK: - Preview
#Preview {
    HomeScreenView()
}
