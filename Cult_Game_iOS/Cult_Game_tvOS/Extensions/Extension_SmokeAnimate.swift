import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 10)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -630, y: -140)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}
