import SwiftUI
import SpriteKit

extension GameStatusView {
    
    var scene: SKScene {
        
//        ripple.position = self.scene.childNode(withName: "stone_water")!.position
        
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
            animateBonfire(in: scene)
            animateFollowers(in: scene)
            
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
