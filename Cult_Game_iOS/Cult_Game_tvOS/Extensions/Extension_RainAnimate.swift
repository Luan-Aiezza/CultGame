import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 470, y: 540)
        emitter.zPosition = 5  // Ajuste para ficar acima do fundo, mas abaixo do pet/personagem

        scene.addChild(emitter)
        
    }
}
