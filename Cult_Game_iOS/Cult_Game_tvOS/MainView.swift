
import SwiftUI
import SpriteKit

struct MainView: View {

    var body: some View {
        ZStack {
            
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            HomeScreenView()
                .ignoresSafeArea(.all)
            
        }.onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
}
