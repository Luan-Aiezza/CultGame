import SpriteKit
import SwiftUI

extension PlayView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "PhoneViewScene.sks") {
            applyLinearFiltering(to: scene)
            animateBonfire(in: scene)
            return scene
            
        } else {
            let fallback = SKScene(size: CGSize(width: 300, height: 300))
            fallback.backgroundColor = .red
            return fallback
        }
    }
    
    func animateBonfire(in scene: SKScene) {
        guard let emitter1 = SKEmitterNode(fileNamed: "BonfirePhone.sks") else {
            print("Não foi possível carregar BonfirePhone.sks")
            return
        }

        emitter1.name = "BonfirePhone"
        emitter1.position = CGPoint(x: 0, y: -22)
        emitter1.zPosition = 5

        // Aplica filtro linear
        scene.addChild(emitter1)
    }
    
    
    // MARK: - Aplica .linear nos nós
    func applyLinearFiltering(to node: SKNode) {
        if let spriteNode = node as? SKSpriteNode, let texture = spriteNode.texture {
            texture.filteringMode = .linear
        }
        
        for child in node.children {
            applyLinearFiltering(to: child)
        }
        
    }
    
}


extension PlayCardView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "PhoneViewScene.sks") {
            applyLinearFiltering(to: scene)
            animateBonfire(in: scene)
            return scene
            
        } else {
            let fallback = SKScene(size: CGSize(width: 300, height: 300))
            fallback.backgroundColor = .red
            return fallback
        }
    }
    
    func animateBonfire(in scene: SKScene) {
        guard let emitter1 = SKEmitterNode(fileNamed: "BonfirePhone.sks") else {
            print("Não foi possível carregar BonfirePhone.sks")
            return
        }

        emitter1.name = "BonfirePhone"
        emitter1.position = CGPoint(x: 0, y: -22)
        emitter1.zPosition = 5

        // Aplica filtro linear
        scene.addChild(emitter1)
    }
    
    
    // MARK: - Aplica .linear nos nós
    func applyLinearFiltering(to node: SKNode) {
        if let spriteNode = node as? SKSpriteNode, let texture = spriteNode.texture {
            texture.filteringMode = .linear
        }
        
        for child in node.children {
            applyLinearFiltering(to: child)
        }
        
    }
    
}

