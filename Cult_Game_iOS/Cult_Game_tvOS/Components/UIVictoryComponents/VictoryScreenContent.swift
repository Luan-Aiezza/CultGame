import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation


// conteudo da tela de vitória (título, descrição, fundo)
struct VictoryScreenContent {
    let title: String
    let description: String
    let backgroundImageName: String

    static func `for`(outcome: GameOutcome) -> VictoryScreenContent {
        switch ( outcome) {
            
        case
            ( .cultistVictoryElimination):
            return .init(
                title: "The cult remained dominant",
                description: "The flame and unity of the cult burned brighter – the heretic was unmasked",
                backgroundImageName: "FilterBlack"
                
            )
            
        case ( .cultistVictoryFollowers):
            return .init(
                title: "The cult remained dominan",
                description: "When the last faithful heart was won, the cultists reached their peak — and the cult reigned supreme.",
                backgroundImageName: "FilterBlack"
            )
            
        case ( .hereticVictoryFollowers):
            return .init(
                title: "The cult has been defeated!",
                description: "There are no souls left to sustain the cult – the followers have reached zero.",
                backgroundImageName: "FilterRed"
            )
            
        case
            ( .hereticVictoryBalance):
            return .init(
                title: "The Cult Was Defeated!",
                description: "The heretic served heresy as if it were faith — and you drank it to the last drop.",
                backgroundImageName: "FilterRed"
            )
        }
    }
}
