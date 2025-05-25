import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}
extension HomeScreenView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}
extension HostGameView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}
extension HowToPlayView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}

extension ResultView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}

extension DiscussionView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}

extension VotingView {
    
    func animateRain(in scene: SKScene) {
        
        guard let emitter = SKEmitterNode(fileNamed: "Rain.sks") else {
            print("Não foi possível carregar Fireflies.sks")
            return
        }
        emitter.name = "Rain"
        emitter.position = CGPoint(x: 520, y: 540)
        emitter.zPosition = 5  // Ajusta para ficar acima do fundo

        scene.addChild(emitter)
        
    }
}
