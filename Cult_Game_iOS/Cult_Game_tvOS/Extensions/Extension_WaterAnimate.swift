import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateWater(in scene: SKScene) {
        
        guard let rippleEmitter = SKEmitterNode(fileNamed: "Ripple") else { return }

        // Posição onde está a pedra
        if let stone = scene.childNode(withName: "stone_water") {
            rippleEmitter.position = stone.position
            rippleEmitter.zPosition = stone.zPosition + 5
            scene.addChild(rippleEmitter)
        }
    }
    
}
