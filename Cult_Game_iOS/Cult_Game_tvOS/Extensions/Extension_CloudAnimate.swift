import SwiftUI
import SpriteKit

extension GameStatusView {
    
    // MARK: - Animação de nuvens
    func animateClouds(in scene: SKScene) {
        for i in 1...14 {
            if let cloud = scene.childNode(withName: "Nuvens/Nuvem_\(i)") as? SKSpriteNode {
                startCloudAnimation(cloud, in: scene)
            }
        }
    }

    func startCloudAnimation(_ cloud: SKSpriteNode, in scene: SKScene) {
        // Define a altura aleatória da nuvem (entre 60% e 90% da altura da cena)
        let minY = scene.size.height * 0.1
        let maxY = scene.size.height * 0.8
        let randomY = CGFloat.random(in: minY...maxY)
        
        let minX = scene.size.width * 0.1
        let maxX = scene.size.width * 0.8
        let randomX = CGFloat.random(in: minX...maxX)

        // Define ponto inicial totalmente à esquerda da cena (fora da tela)
        let startX = -cloud.size.width - randomX - scene.size.width

        // Define ponto final totalmente à direita da cena (fora da tela)
        let endX = scene.size.width*2 + cloud.size.width

        // Define posição inicial com y aleatório
        cloud.position = CGPoint(x: startX, y: randomY)

        // Define a velocidade (pontos por segundo) e duração com base no tamanho da cena
        let speed: CGFloat = 100.0
        let distance = endX - startX
        let duration = TimeInterval(distance / speed)

        // Define a ação de mover para o ponto final
        let moveRight = SKAction.moveTo(x: endX, duration: duration)

        // Quando chegar ao fim, reseta a posição e randomiza o Y novamente
        let reset = SKAction.run {
            let newY = CGFloat.random(in: minY...maxY)
            cloud.position = CGPoint(x: startX, y: newY)
        }

        // Sequência de mover → resetar → repetir
        let sequence = SKAction.sequence([moveRight, reset])
        let loop = SKAction.repeatForever(sequence)

        cloud.run(loop)
    }
    
}
