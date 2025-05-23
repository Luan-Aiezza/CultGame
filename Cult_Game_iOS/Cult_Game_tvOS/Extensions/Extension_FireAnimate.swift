import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateFire(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Fire1"
        emitter1.position = CGPoint(x: -570, y: 365)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Fire2"
        emitter2.position = CGPoint(x: -550, y: 360)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo
        scene.addChild(emitter2)
    }
}

extension TvTransitionTextsView {
    
    func animateFire(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Fire1"
        emitter1.position = CGPoint(x: -570, y: 365)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Fire2"
        emitter2.position = CGPoint(x: -550, y: 360)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo
        scene.addChild(emitter2)
    }
}


extension VictoryTvView {
    
    func animateFire(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Fire1"
        emitter1.position = CGPoint(x: -570, y: 365)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Fire.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Fire2"
        emitter2.position = CGPoint(x: -550, y: 360)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo
        scene.addChild(emitter2)
    }
}
