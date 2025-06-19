
import SwiftUI
import SpriteKit

struct MainViewiOS: View {

    var body: some View {
        ZStack {
            
            SpriteView(scene: scene, debugOptions: [.showsDrawCount, .showsFPS, .showsNodeCount])
                .ignoresSafeArea()
            
            PlayView()
                .ignoresSafeArea(.all)
                .background(Color.clear)
        }
    }
}
