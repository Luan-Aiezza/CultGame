import SwiftUI
import SpriteKit

extension GameStatusView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
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

extension HowToPlayView1 {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateRain(in: scene)
            animateSmoke(in: scene)
            
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

extension HostGameView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateFireflies(in: scene)
            animateBonfire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
            
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

extension HomeScreenView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateFireflies(in: scene)
            animateFire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
            
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


extension TvTransitionTextsView {
    
    var scene: SKScene {
        
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
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

extension GameRoundView {
    
    var scene: SKScene {
        
        if let scene = SKScene(fileNamed: "BackViewScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
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


extension VictoryTvView {
    
    var scene: SKScene {
        
//        ripple.position = self.scene.childNode(withName: "stone_water")!.position
        
        if let scene = SKScene(fileNamed: "BackViewScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
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

extension ResultView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
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

extension DiscussionView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
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

extension VotingView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "MyScene") {
            scene.scaleMode = .aspectFill
            applyLinearFiltering(to: scene)
            //animateClouds(in: scene) // <- Animação das nuvens
            animateTrees(in: scene)
            animateFireflies(in: scene)
            animateFire(in: scene)
            animateRain(in: scene)
            animateSmoke(in: scene)
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

extension VotingResultView {
    
    var scene: SKScene {
        if let scene = SKScene(fileNamed: "BackViewScene") {
            scene.scaleMode = .aspectFill
            animateFire(in: scene)

            
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

//extension HowToPlayView1 {
//    
//    var scene: SKScene {
//        if let scene = SKScene(fileNamed: "MyScene") {
//            scene.scaleMode = .aspectFill
//            applyLinearFiltering(to: scene)
//            //animateClouds(in: scene) // <- Animação das nuvens
//            animateFireflies(in: scene)
//            animateFire(in: scene)
//            animateRain(in: scene)
//            animateSmoke(in: scene)
//            
//            return scene
//        } else {
//            let fallback = SKScene(size: CGSize(width: 300, height: 300))
//            fallback.backgroundColor = .red
//            return fallback
//        }
//    }
//    
//    // MARK: - Aplica .linear nos nós
//    func applyLinearFiltering(to node: SKNode) {
//        if let spriteNode = node as? SKSpriteNode, let texture = spriteNode.texture {
//            texture.filteringMode = .linear
//        }
//        
//        for child in node.children {
//            applyLinearFiltering(to: child)
//        }
//        
//    }
//    
//}
