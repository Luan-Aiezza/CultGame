import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

/// TODO: eSPACAMENTO ENRE AS LINHAS DE TEXTO
/// BOTAO DE SAIR DA PARTIDA

// View que exibe o personagem herege com um efeito de brilho animado e um círculo pulsante
struct GlowingCircleView: View {
    let characterImageName: String
    @State private var animateGlow = false
    @State private var angle: Double = 0
    
    let baseColor = Color(red: 0.282, green: 0.043, blue: 0.004) // #480B01
    
    var body: some View {
        ZStack {
            
            Image(characterImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 300)
                .offset(x: 0, y: 10)
            
            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.4),
                            Color.red.opacity(0.9),
                            Color.red.opacity(0.4)
                        ]),
                        startPoint: animateGlow ? .leading : .trailing,
                        endPoint: animateGlow ? .trailing : .leading
                    ),
                    lineWidth: 10
                )
                .frame(width: 300, height: 280)
                .blur(radius: 4)
                .opacity(0.8)
        }
        .onAppear {
            animateGlow = true
            withAnimation(Animation.linear(duration: 9).repeatForever(autoreverses: false)) {
                angle = 360
            }
        }
    }
}
