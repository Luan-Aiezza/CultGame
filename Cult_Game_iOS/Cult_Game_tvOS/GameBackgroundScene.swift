import SpriteKit

class GameBackgroundScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear

        // Carrega o Tile Map da cena .sks
        if let tileMapScene = SKScene(fileNamed: "MyScene"),
           let tileMap = tileMapScene.childNode(withName: "Tile Map Node") as? SKTileMapNode {
            tileMap.position = CGPoint(x: frame.midX, y: frame.midY)
            tileMap.zPosition = -1 // garante que fique no fundo
            addChild(tileMap)
        }
    }
}
