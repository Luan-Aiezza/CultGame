import SwiftUI

struct VictoryScreenContent {
    let title: String
    let description: String
    let backgroundImageName: String
    
    
    static func `for`(role: PlayerRole, outcome: GameOutcome) -> VictoryScreenContent {
        switch (role, outcome) {
            
        case (.cultist, .cultistVictoryFollowers),
            (.cultist, .cultistVictoryElimination):
            return .init(
                title: "The Cult Has Triumphed!",
                description: "The flame and unity of the cult burned brighter.",
                backgroundImageName: "CultistVictory"
            )
            
        case (.heretic, .cultistVictoryFollowers),
            (.heretic, .cultistVictoryElimination):
            return .init(
                title: "You Were Discovered!",
                description: "Heresy whispered too much. The cult heard. Now, the veil of lies burns in flames.",
                backgroundImageName: "CultistVictory"
            )
            
        case (.heretic, .hereticVictoryFollowers),
            (.heretic, .hereticVictoryBalance):
            return .init(
                title: "You Have Won!",
                description: "You served heresy as if it were faith — and they drank it to the last drop.",
                backgroundImageName: "HereticVictory"
            )
            
        case (.cultist, .hereticVictoryFollowers),
            (.cultist, .hereticVictoryBalance):
            return .init(
                title: "The Cult Was Defeated!",
                description: "The heretic served heresy as if it were faith — and you drank it to the last drop.",
                backgroundImageName: "HereticVictory"
            )
        }
    }
}
