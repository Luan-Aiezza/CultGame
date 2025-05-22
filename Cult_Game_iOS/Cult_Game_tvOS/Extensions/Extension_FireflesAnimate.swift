import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateFireflies(in scene: SKScene) {
        guard let emitter = SKEmitterNode(fileNamed: "Fireflies.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter.name = "Fireflies"
        emitter.position = CGPoint(x: scene.size.width-scene.size.width, y: scene.size.height/4)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo
        emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: scene.size.height)

        scene.addChild(emitter)
    }
    
}
extension GameRoundView {
    
    func animateFireflies(in scene: SKScene) {
        guard let emitter = SKEmitterNode(fileNamed: "Fireflies.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter.name = "Fireflies"
        emitter.position = CGPoint(x: scene.size.width-scene.size.width, y: scene.size.height/4)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo
        emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: scene.size.height)

        scene.addChild(emitter)
    }
    
}
extension HomeScreenView {
    
    func animateFireflies(in scene: SKScene) {
        guard let emitter = SKEmitterNode(fileNamed: "Fireflies.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter.name = "Fireflies"
        emitter.position = CGPoint(x: scene.size.width-scene.size.width, y: scene.size.height/4)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo
        emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: scene.size.height)

        scene.addChild(emitter)
    }
    
}
extension HostGameView {
    
    func animateFireflies(in scene: SKScene) {
        guard let emitter = SKEmitterNode(fileNamed: "Fireflies.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter.name = "Fireflies"
        emitter.position = CGPoint(x: scene.size.width-scene.size.width, y: scene.size.height/4)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo
        emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: scene.size.height)

        scene.addChild(emitter)
    }
    
}

extension TvTransitionTextsView {
    
    func animateFireflies(in scene: SKScene) {
        guard let emitter = SKEmitterNode(fileNamed: "Fireflies.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter.name = "Fireflies"
        emitter.position = CGPoint(x: scene.size.width-scene.size.width, y: scene.size.height/4)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo
        emitter.particlePositionRange = CGVector(dx: scene.size.width, dy: scene.size.height)

        scene.addChild(emitter)
    }
    
}
