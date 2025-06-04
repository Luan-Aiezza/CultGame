import SwiftUI
import SpriteKit

public class MainScene: SKScene {
    
    public static var shared: MainScene?
    
    public static func create() -> MainScene {
        if let scene = SKScene(fileNamed: "MyScene") as? MainScene {
            scene.scaleMode = .aspectFill
            shared = scene
            return scene
        }
        return MainScene(size: .init(width: 300, height: 300))
    }
    
    public func zoomIn() {
        if let camera {
            camera.run(.move(to: CGPoint(x: 0, y: 100), duration: 0.0))
            camera.run(.scale(to: 0.4, duration: 0.75))
        }
    }
    
    public func zoomOut() {
        if let camera {
            camera.run(.move(to: CGPoint(x: 0, y: 0), duration: 0.0))
            camera.run(.scale(to: 1, duration: 0.75))
        }
    }
    
}

extension MainView {
    
    var scene: MainScene {
        let scene = MainScene.create()
        scene.scaleMode = .aspectFill
        applyLinearFiltering(to: scene)
        animateClouds(in: scene) // <- Animação das nuvens
        animateTrees(in: scene)
        animateFireflies(in: scene)
        animateFire(in: scene)
        animateRain(in: scene)
        animateSmoke(in: scene)
        animateBonfire(in: scene)
        //animateFollowers(in: scene)
        
        return scene
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

extension Cult_Game_tvOSApp {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            animateTrees(in: scene)
            animateBonfire(in: scene)
            
            return scene
        } else {
            let fallback = SKScene(size: CGSize(width: 300, height: 300))
            fallback.backgroundColor = .red
            return fallback
        }
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
