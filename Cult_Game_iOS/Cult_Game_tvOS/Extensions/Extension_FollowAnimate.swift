import SwiftUI
import SpriteKit

extension GameStatusView {
    
    func animateFollowers(in scene: SKScene) {
        guard let centerNode = scene.childNode(withName: "*/Fogueira") else {
            print("Node 'Fogueira' não encontrado.")
            return
        }

        let offsetX: CGFloat = 290
        let offsetY: CGFloat = 50
        let center = CGPoint(x: centerNode.position.x + offsetX, y: centerNode.position.y - offsetY)
        let radius: CGFloat = 130
        let followerCount = 10

        for i in 0..<followerCount {
            let follower = SKSpriteNode(imageNamed: "Seguidor")
            follower.lightingBitMask = 1
            follower.name = "Follower_\(i)"
            follower.zPosition = -1
            follower.setScale(0.03)

            // Distribuição circular inicial
            let angle = CGFloat(i) / CGFloat(followerCount) * .pi * 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            follower.position = CGPoint(x: x, y: y)
            scene.addChild(follower)

            // Caminho circular
            let path = CGMutablePath()
            path.addArc(center: center,
                        radius: radius,
                        startAngle: angle,
                        endAngle: angle + (.pi * 2),
                        clockwise: false)
            let follow = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 10.0)
            let loop = SKAction.repeatForever(follow)
            follower.run(loop)

            // Idle (achatamento vertical)
            let idleDown = SKAction.scaleY(to: 0.025, duration: 0.4)
            let idleUp = SKAction.scaleY(to: 0.03, duration: 0.4)
            let idle = SKAction.repeatForever(SKAction.sequence([idleDown, idleUp]))
            follower.run(idle)

            // Animações orgânicas para todos (variação de rotação e escala em X)
            let tiltLeft = SKAction.rotate(byAngle: .pi / 48, duration: 1.0)
            let tiltRight = SKAction.rotate(byAngle: -.pi / 48, duration: 1.0)
            let tiltLoop = SKAction.repeatForever(SKAction.sequence([tiltLeft, tiltRight]))
            follower.run(tiltLoop)

            let scaleXDown = SKAction.scaleX(to: 0.03, duration: 1.0)
            let scaleXUp = SKAction.scaleX(to: 0.025, duration: 1.0)
            let scaleLoop = SKAction.repeatForever(SKAction.sequence([scaleXDown, scaleXUp]))
            follower.run(scaleLoop)

            // Dispersão para frente e para trás (apenas metade deles)
            if i % 2 == 0 {
                let dx = 8 * cos(angle)
                let dy = 8 * sin(angle)

                // Randomiza a velocidade da oscilação
                let duration = Double.random(in: 1.0...2.0)

                let forward = SKAction.moveBy(x: dx, y: dy, duration: duration)
                let backward = SKAction.moveBy(x: -dx, y: -dy, duration: duration)
                let wiggle = SKAction.repeatForever(SKAction.sequence([forward, backward]))
                follower.run(wiggle)
            }
        }
    }

}


extension DiscussionView {
    
    func animateFollowers(in scene: SKScene) {
        guard let centerNode = scene.childNode(withName: "*/Fogueira") else {
            print("Node 'Fogueira' não encontrado.")
            return
        }

        let offsetX: CGFloat = 290
        let offsetY: CGFloat = 50
        let center = CGPoint(x: centerNode.position.x + offsetX, y: centerNode.position.y - offsetY)
        let radius: CGFloat = 130
        let followerCount = 10

        for i in 0..<followerCount {
            let follower = SKSpriteNode(imageNamed: "Seguidor")
            follower.lightingBitMask = 1
            follower.name = "Follower_\(i)"
            follower.zPosition = -1
            follower.setScale(0.03)

            // Distribuição circular inicial
            let angle = CGFloat(i) / CGFloat(followerCount) * .pi * 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            follower.position = CGPoint(x: x, y: y)
            scene.addChild(follower)

            // Caminho circular
            let path = CGMutablePath()
            path.addArc(center: center,
                        radius: radius,
                        startAngle: angle,
                        endAngle: angle + (.pi * 2),
                        clockwise: false)
            let follow = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 10.0)
            let loop = SKAction.repeatForever(follow)
            follower.run(loop)

            // Idle (achatamento vertical)
            let idleDown = SKAction.scaleY(to: 0.025, duration: 0.4)
            let idleUp = SKAction.scaleY(to: 0.03, duration: 0.4)
            let idle = SKAction.repeatForever(SKAction.sequence([idleDown, idleUp]))
            follower.run(idle)

            // Animações orgânicas para todos (variação de rotação e escala em X)
            let tiltLeft = SKAction.rotate(byAngle: .pi / 48, duration: 1.0)
            let tiltRight = SKAction.rotate(byAngle: -.pi / 48, duration: 1.0)
            let tiltLoop = SKAction.repeatForever(SKAction.sequence([tiltLeft, tiltRight]))
            follower.run(tiltLoop)

            let scaleXDown = SKAction.scaleX(to: 0.03, duration: 1.0)
            let scaleXUp = SKAction.scaleX(to: 0.025, duration: 1.0)
            let scaleLoop = SKAction.repeatForever(SKAction.sequence([scaleXDown, scaleXUp]))
            follower.run(scaleLoop)

            // Dispersão para frente e para trás (apenas metade deles)
            if i % 2 == 0 {
                let dx = 8 * cos(angle)
                let dy = 8 * sin(angle)

                // Randomiza a velocidade da oscilação
                let duration = Double.random(in: 1.0...2.0)

                let forward = SKAction.moveBy(x: dx, y: dy, duration: duration)
                let backward = SKAction.moveBy(x: -dx, y: -dy, duration: duration)
                let wiggle = SKAction.repeatForever(SKAction.sequence([forward, backward]))
                follower.run(wiggle)
            }
        }
    }

}

extension VotingView {
    
    func animateFollowers(in scene: SKScene) {
        guard let centerNode = scene.childNode(withName: "*/Fogueira") else {
            print("Node 'Fogueira' não encontrado.")
            return
        }

        let offsetX: CGFloat = 290
        let offsetY: CGFloat = 50
        let center = CGPoint(x: centerNode.position.x + offsetX, y: centerNode.position.y - offsetY)
        let radius: CGFloat = 130
        let followerCount = 10

        for i in 0..<followerCount {
            let follower = SKSpriteNode(imageNamed: "Seguidor")
            follower.lightingBitMask = 1
            follower.name = "Follower_\(i)"
            follower.zPosition = -1
            follower.setScale(0.03)

            // Distribuição circular inicial
            let angle = CGFloat(i) / CGFloat(followerCount) * .pi * 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            follower.position = CGPoint(x: x, y: y)
            scene.addChild(follower)

            // Caminho circular
            let path = CGMutablePath()
            path.addArc(center: center,
                        radius: radius,
                        startAngle: angle,
                        endAngle: angle + (.pi * 2),
                        clockwise: false)
            let follow = SKAction.follow(path, asOffset: false, orientToPath: false, duration: 10.0)
            let loop = SKAction.repeatForever(follow)
            follower.run(loop)

            // Idle (achatamento vertical)
            let idleDown = SKAction.scaleY(to: 0.025, duration: 0.4)
            let idleUp = SKAction.scaleY(to: 0.03, duration: 0.4)
            let idle = SKAction.repeatForever(SKAction.sequence([idleDown, idleUp]))
            follower.run(idle)

            // Animações orgânicas para todos (variação de rotação e escala em X)
            let tiltLeft = SKAction.rotate(byAngle: .pi / 48, duration: 1.0)
            let tiltRight = SKAction.rotate(byAngle: -.pi / 48, duration: 1.0)
            let tiltLoop = SKAction.repeatForever(SKAction.sequence([tiltLeft, tiltRight]))
            follower.run(tiltLoop)

            let scaleXDown = SKAction.scaleX(to: 0.03, duration: 1.0)
            let scaleXUp = SKAction.scaleX(to: 0.025, duration: 1.0)
            let scaleLoop = SKAction.repeatForever(SKAction.sequence([scaleXDown, scaleXUp]))
            follower.run(scaleLoop)

            // Dispersão para frente e para trás (apenas metade deles)
            if i % 2 == 0 {
                let dx = 8 * cos(angle)
                let dy = 8 * sin(angle)

                // Randomiza a velocidade da oscilação
                let duration = Double.random(in: 1.0...2.0)

                let forward = SKAction.moveBy(x: dx, y: dy, duration: duration)
                let backward = SKAction.moveBy(x: -dx, y: -dy, duration: duration)
                let wiggle = SKAction.repeatForever(SKAction.sequence([forward, backward]))
                follower.run(wiggle)
            }
        }
    }

}
