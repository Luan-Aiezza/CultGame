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
            //animateWater(in: scene)
            
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

        if let tileMapNode = node.childNode(withName: "*/Tree") as? SKTileMapNode {
            addFilteringMode(tileMap: tileMapNode)
        }
    }

    func addFilteringMode(tileMap: SKTileMapNode) {
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                if let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row) {
                    tileDefinition.textures[0].filteringMode = .linear
                }
            }
        }
    }
}
