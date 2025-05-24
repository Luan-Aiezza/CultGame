import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

//exibe a imagem do herege derrotado, escurecendo gradualmente e desaparecendo com fade-out
struct HereticDefeatImageView: View {
    let imageName: String
    
    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: -135, y: -350)
            .frame(width: 150, height: 160)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece imagem
            .opacity(fadeOut) // fade out da imagem
            .onAppear {
                withAnimation(.easeIn(duration: 18)) {
                    darkness = 1.0 // totalmente preto
                }
                withAnimation(.easeOut(duration: 17).delay(2)) {
                    fadeOut = 0.0 // desaparece
                }
            }
    }
}
