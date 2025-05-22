import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateBonfire(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "FireBonfire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Bonfire"
        emitter1.position = CGPoint(x: 5, y: -22)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter1)
    }
    
}

extension GameRoundView {
    
    func animateBonfire(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "FireBonfire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Bonfire"
        emitter1.position = CGPoint(x: 5, y: -22)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter1)
    }
}

