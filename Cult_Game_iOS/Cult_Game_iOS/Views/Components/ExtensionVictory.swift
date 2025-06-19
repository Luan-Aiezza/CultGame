import SpriteKit
import SwiftUI

extension GameOutcome {
    var isHereticVictory: Bool {
        self == .hereticVictoryFollowers || self == .hereticVictoryBalance
    }
}
extension GameOutcome {
    var isCultistVictory: Bool {
        self == .cultistVictoryFollowers || self == .cultistVictoryElimination
    }
}
