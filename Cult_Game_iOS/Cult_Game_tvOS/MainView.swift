
import SwiftUI
import SpriteKit

struct MainView: View {

    var body: some View {
        ZStack {
            
            SpriteView(scene: scene, debugOptions: [.showsDrawCount, .showsFPS, .showsNodeCount])
                .ignoresSafeArea()
            
            HomeScreenView()
                .ignoresSafeArea(.all)
            
        }
    }
}
