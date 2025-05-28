import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}
extension HomeScreenView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}
extension HostGameView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}
//extension HowToPlayView {
//    
//    func animateSmoke(in scene: SKScene) {
//        
//        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
//            print("Não foi possível carregar Fireflies.sks")
//            return
//        }
//        emitter1.name = "Smoke1"
//        emitter1.position = CGPoint(x: -590, y: 15)
//        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.
//
//        scene.addChild(emitter1)
//        
//        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
//            print("Não foi possível carregar Fireflies.sks")
//            return
//        }
//
//        emitter2.name = "Smoke1"
//        emitter2.position = CGPoint(x: -625, y: -135)
//        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
//        scene.addChild(emitter2)
//    }
//}

extension ResultView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}

extension DiscussionView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}

extension VotingView {
    
    func animateSmoke(in scene: SKScene) {
        
        guard let emitter1 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter1.name = "Smoke1"
        emitter1.position = CGPoint(x: -590, y: 15)
        emitter1.zPosition = 5  // Ajusta para ficar acima do fundo.

        scene.addChild(emitter1)
        
        guard let emitter2 = SKEmitterNode(fileNamed: "Smoke.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }

        emitter2.name = "Smoke1"
        emitter2.position = CGPoint(x: -625, y: -135)
        emitter2.zPosition = 5  // Ajusta para ficar acima do fundo.
        scene.addChild(emitter2)
    }
}

