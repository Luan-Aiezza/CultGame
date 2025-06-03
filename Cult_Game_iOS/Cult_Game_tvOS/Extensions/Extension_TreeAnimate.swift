import SwiftUI
import SpriteKit

extension MainView {//aqui
    
    // MARK: - Animação de árvores
    func animateTrees(in scene: SKScene) {
        for i in 1...258{
            if let tree = scene.childNode(withName: "*/tree_\(i)") as? SKSpriteNode {
                applyWindEffect(to: tree)
            }
        }
    }

    func applyWindEffect(to tree: SKSpriteNode) {
        // Salva a posição original
        let originalPosition = tree.position

        // Define o novo ponto de ancoragem
        tree.anchorPoint = CGPoint(x: 0.5, y: 0.1)

        // Compensa o deslocamento vertical causado pela mudança no anchorPoint
        let deltaY = tree.size.height * (0.5 - 0.1) // Diferença de 40% da altura
        tree.position = CGPoint(x: originalPosition.x, y: originalPosition.y - deltaY)

        // Define a rotação de balanço (em radianos)
        let angle: CGFloat = .pi / 180 * 2  // ~2 graus

        // Define as ações de balanço
        let swayRight = SKAction.rotate(byAngle: angle, duration: 1.2)
        let swayLeft = SKAction.rotate(byAngle: -angle * 2, duration: 1.2)
        let swayCenter = SKAction.rotate(byAngle: angle, duration: 1.2)

        let sequence = SKAction.sequence([
            swayRight,
            swayLeft,
            swayCenter
//            .move(by: .init(dx: 0, dy: -5), duration: 1.2),
//            .move(by: .init(dx: 0, dy: 5), duration: 1.2),
        ])
        let loop = SKAction.repeatForever(sequence)

        // Desfasamento aleatório por naturalidade
        let delay = Double.random(in: 0.0...1.5)
        tree.run(SKAction.sequence([
            .wait(forDuration: delay),
            loop
        ]))
    }
}

extension Cult_Game_tvOSApp {//aqui
    
    // MARK: - Animação de árvores
    func animateTrees(in scene: SKScene) {
        for i in 1...258{
            if let tree = scene.childNode(withName: "*/tree_\(i)") as? SKSpriteNode {
                applyWindEffect(to: tree)
            }
        }
    }

    func applyWindEffect(to tree: SKSpriteNode) {
        // Salva a posição original
        let originalPosition = tree.position

        // Define o novo ponto de ancoragem
        tree.anchorPoint = CGPoint(x: 0.5, y: 0.1)

        // Compensa o deslocamento vertical causado pela mudança no anchorPoint
        let deltaY = tree.size.height * (0.5 - 0.1) // Diferença de 40% da altura
        tree.position = CGPoint(x: originalPosition.x, y: originalPosition.y - deltaY)

        // Define a rotação de balanço (em radianos)
        let angle: CGFloat = .pi / 180 * 2  // ~2 graus

        // Define as ações de balanço
        let swayRight = SKAction.rotate(byAngle: angle, duration: 1.2)
        let swayLeft = SKAction.rotate(byAngle: -angle * 2, duration: 1.2)
        let swayCenter = SKAction.rotate(byAngle: angle, duration: 1.2)

        let sequence = SKAction.sequence([
            swayRight,
            swayLeft,
            swayCenter
//            .move(by: .init(dx: 0, dy: -5), duration: 1.2),
//            .move(by: .init(dx: 0, dy: 5), duration: 1.2),
        ])
        let loop = SKAction.repeatForever(sequence)

        // Desfasamento aleatório por naturalidade
        let delay = Double.random(in: 0.0...1.5)
        tree.run(SKAction.sequence([
            .wait(forDuration: delay),
            loop
        ]))
    }
}
