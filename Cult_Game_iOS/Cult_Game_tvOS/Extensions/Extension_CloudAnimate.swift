import SwiftUI
import SpriteKit

extension MainView {
    
    // MARK: - Animação de nuvens
    func animateClouds(in scene: SKScene) {
        guard let smoke = SKEmitterNode(fileNamed: "Cloud.sks") else {
            print("Não foi possível carregar SmokeCloud.sks")
            return
        }

        smoke.position = CGPoint(x: scene.size.width/6 - scene.size.width, y: 100)
        smoke.zPosition = 6 // atrás de tudo, como plano de fundo

        // Altera o alcance de emissão para preencher toda a altura da cena
        //smoke.particlePositionRange = CGVector(dx: 0, dy: sceneWidth)

        // Adiciona à cena
        scene.addChild(smoke)
    }
    
}
