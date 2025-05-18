import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -625, y: -40)
        emitter1.zPosition = 5  // Ajuste para ficar acima do fundo, mas abaixo do pet/personagem

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -655, y: -165)
        emitter2.zPosition = 5  // Ajuste para ficar acima do fundo, mas abaixo do pet/personagem
        scene.addChild(emitter2)
    }
}
