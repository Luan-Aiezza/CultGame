import SwiftUI
import SpriteKit
import AVFoundation

// MARK: - View do Herege Derrotado com Efeito Visual
struct HereticDefeatImageView: View {
    let imageName: String
    
    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 160)
            .offset(y: -350)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece gradualmente
            .opacity(fadeOut) // desaparece gradualmente
            .onAppear {
                withAnimation(.easeIn(duration: 18)) {
                    darkness = 1.0
                }
                withAnimation(.easeOut(duration: 17).delay(2)) {
                    fadeOut = 0.0
                }
            }
    }
}
