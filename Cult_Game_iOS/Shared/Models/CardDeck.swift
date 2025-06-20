//
//  CardDeck.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 15/05/25.
//

import Foundation

public class CardDeck {
    
    let commonCards: [Card] = [
        Card(name: "Offering", faithCost: 3, heresyCost: 0, followersEffect: 6, effectsDescription: "", description: "Silent offers are placed on the altas, strengthening invisible bonds with the divine", imageName: "flower", type: .common, rarity: 1),
        Card(name: "Fog Veil", faithCost: 3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "A dense fog covers the lake, creating a space for deep meditation", imageName: "hood", type: .common, rarity: 1),
        Card(name: "Path of Pain", faithCost: 6, heresyCost: 0, followersEffect: -3, effectsDescription: "", description: "Only the strongest go up the hill and come back stronger", imageName: "path", type: .common, rarity: 1),
        Card(name: "Star Song", faithCost: 3, heresyCost: 0, followersEffect: 1, effectsDescription: "", description: "By the fire and under the stars, the cultists sing old ballads that warms their spirit", imageName: "stars", type: .common, rarity: 1),
        Card(name: "Aurora Vigil", faithCost: 6, heresyCost: 0, followersEffect: -3, effectsDescription: "", description: "The most faithful of them go up the hill, looking at the sky for guidance. The will renovates the faith.", imageName: "sun", type: .common, rarity: 1),
        Card(name: "Day Vigil", faithCost: 8, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "The people reunites for a day vigil. IT strengthens their bond.", imageName: "eye", type: .common, rarity: 1),
        Card(name: "Meditation", faithCost: 4, heresyCost: 0, followersEffect: 2, effectsDescription: "", description: "Silence fills the village. It is very calm.", imageName: "lilly", type: .common, rarity: 1),
        Card(name: "Blasphemy", faithCost: -3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "You've spoken blasphemy against your God.", imageName: "blasphemy", type: .common, rarity: 1),
        Card(name: "Wronged Ritual", faithCost: -3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "One wrong gesture, one symbol drawn backwards — the energy dissipates before it reaches its purpose.", imageName: "hood", type: .common, rarity: 1),
        Card(name: "Wronged Ritual", faithCost: -3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "One wrong gesture, one symbol drawn backwards — the energy dissipates before it reaches its purpose.", imageName: "ritual", type: .common, rarity: 1),
        Card(name: "Fragment", faithCost: -3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "A sacred artifact shatters. Its glow fades, taking part of the belief with it.", imageName: "crystal", type: .common, rarity: 1),
        Card(name: "Divine Advice", faithCost: 6, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "You listen to the old teachings.", imageName: "feather", type: .common, rarity: 1),
        Card(name: "Silent Pact", faithCost: 3, heresyCost: 0, followersEffect: -1, effectsDescription: "", description: "Secrets are kept at all costs. Faith is maintained, but at the cost of trust.", imageName: "key", type: .common, rarity: 1),
        Card(name: "Water", faithCost: 3, heresyCost: 0, followersEffect: 0, effectsDescription: "", description: "Devotees immerse themselves in the holy waters, ridding themselves of spiritual impurities and doubts.", imageName: "water", type: .common, rarity: 1),
        Card(name: "Blood Pact", faithCost: 3, heresyCost: 0, followersEffect: 1, effectsDescription: "", description: "At the altar, the faithful offer part of themselves in the name of worship, sealing their loyalty.", imageName: "cup", type: .common, rarity: 1),
        Card(name: "Mission", faithCost: 12, heresyCost: 0, followersEffect: -5, effectsDescription: "", description: "A group of brothers set out on a mission to take their word to distant lands.", imageName: "brothers", type: .common, rarity: 1),
        Card(name: "Fight", faithCost: 0, heresyCost: 0, followersEffect: -3, effectsDescription: "", description: "A group begins to question the leadership. Even without proof, the shock spreads.", imageName: "mask", type: .common, rarity: 1),
        Card(name: "Soul Sick", faithCost: 0, heresyCost: 0, followersEffect: -3, effectsDescription: "", description: "An unknown affliction affects the faithful. It is not of the body—it is of the soul.", imageName: "sickness", type: .common, rarity: 1),
        Card(name: "Sacrifice", faithCost: 0, heresyCost: 0, followersEffect: -5, effectsDescription: "", description: "An accident during the ritual takes more than was intended to be offered.", imageName: "initiation", type: .common, rarity: 1),
        Card(name: "Sickness", faithCost: 0, heresyCost: 0, followersEffect: -3, effectsDescription: "", description: "A mysterious illness strikes the community. Many question divine protection.", imageName: "sickness", type: .common, rarity: 1),
        Card(name: "Up the Hill", faithCost: 12, heresyCost: 0, followersEffect: -9, effectsDescription: "", description: "Devotees go to the mountain for a pilgrimage. Their faith inspires others to follow in their footsteps.", imageName: "send", type: .common, rarity: 1),
        Card(name: "Lake", faithCost: -5, heresyCost: 0, followersEffect: 10, effectsDescription: "", description: "Take community members on a lake retreat", imageName: "water", type: .common, rarity: 1),
        Card(name: "Village", faithCost: -3, heresyCost: 0, followersEffect: 5, effectsDescription: "", description: "You visited a village and attracted more believers.", imageName: "village", type: .common, rarity: 1),
        Card(name: "Revelation", faithCost: -3, heresyCost: 0, followersEffect: 3, effectsDescription: "", description: "A vision strengthens the bonds of the cult, attracting new followers.", imageName: "goddess", type: .common, rarity: 1),
        Card(name: "Initiation", faithCost: -3, heresyCost: 0, followersEffect: 6, effectsDescription: "", description: "New members are brought into the inner circle.", imageName: "initiation", type: .common, rarity: 1)
        
    ]

    var cultistCards: [Card] = [
        Card(name: "Sacred Village", faithCost: 0, heresyCost: 0, followersEffect: 3, effectsDescription: "", description: "A representative of the cult brings blessings to the village, consolidating new followers.", imageName: "village", type: .common, rarity: 1),
        Card(name: "Prophecy", faithCost: 0, heresyCost: 0, followersEffect: 6, effectsDescription: "", description: "An ancient prophecy preached by you comes true. The faithful multiply.", imageName: "writing", type: .common, rarity: 1),
        Card(name: "Stars", faithCost: -6, heresyCost: 0, followersEffect: 3, effectsDescription: "", description: "A star crosses the sky exactly as predicted in the sacred writings.", imageName: "stars", type: .common, rarity: 1)
    ]

    let heresyCards: [Card] = [
        Card(name: "Profanation", faithCost: 0, heresyCost: -3, followersEffect: -5, effectsDescription: "", description: "Whispers about forgotten gods infiltrate among the faithful. Gradually, eyes turn to other altars.", imageName: "skull", type: .heresy, rarity: 5),
        Card(name: "Rumors", faithCost: 0, heresyCost: -1, followersEffect: -3, effectsDescription: "", description: "The heretic spreads encrypted messages among the villagers, planting the seed of chaos.", imageName: "book", type: .heresy, rarity: 5),
        Card(name: "False Prophet", faithCost: 0, heresyCost: -3, followersEffect: -9, effectsDescription: "", description: "The heretic appears as a prophet, leadind the faithful astray.", imageName: "cross", type: .heresy, rarity: 5),
        Card(name: "Doubt", faithCost: 0, heresyCost: -3, followersEffect: -10, effectsDescription: "", description: "Twisted tales and veiled suspicions spread like smoke among the faithful. The leader's figure can no longer be seen with the same trust.", imageName: "leader", type: .heresy, rarity: 5),
        Card(name: "Corruption", faithCost: -6, heresyCost: -1, followersEffect: 0, effectsDescription: "", description: "A faithful follower is corrupted from inside. The faith seems immaculate, but is poisoned.", imageName: "hear", type: .heresy, rarity: 5),
        Card(name: "Poetry", faithCost: 0, heresyCost: -3, followersEffect: -9, effectsDescription: "", description: "Ancient verses are recited covertly in the village, seducing restless minds.", imageName: "symbol", type: .heresy, rarity: 5),
        Card(name: "Mirrored Rite", faithCost: -6, heresyCost: -3, followersEffect: 0, effectsDescription: "", description: "The heretic performs a ritual just like the cultist, but calling for strange forces.", imageName: "candle", type: .heresy, rarity: 5),
        Card(name: "Foreign Word", faithCost: 0, heresyCost: 3, followersEffect: -9, effectsDescription: "", description: "Whispers about forgotten gods infiltrate among the faithful. Gradually, eyes turn to other altars.", imageName: "altar", type: .heresy, rarity: 5),
        Card(name: "Shattered Name", faithCost: 0, heresyCost: 3, followersEffect: 0, effectsDescription: "", description: "A forgotten word is whispered on the hill. Whoever hears it is never the same again.", imageName: "smoke", type: .heresy, rarity: 5),
        Card(name: "Unbeliever", faithCost: -6, heresyCost: -3, followersEffect: 0, effectsDescription: "", description: "The heretic proclaims their doubts from the mountaintop, and their voice echoes through the forest.", imageName: "pleading", type: .heresy, rarity: 5),
        Card(name: "The Murmur", faithCost: 0, heresyCost: -1, followersEffect: -6, effectsDescription: "", description: "Whispered words in the darkness make the faithful question their devotion.", imageName: "ghosts", type: .heresy, rarity: 5),
        Card(name: "The Spread", faithCost: 0, heresyCost: -3, followersEffect: -10, effectsDescription: "", description: "The heretic spreads rumors among the villagers, leading them to abandon the doctrine.", imageName: "mouth", type: .heresy, rarity: 5),
        Card(name: "Faith Divided", faithCost: 0, heresyCost: -3, followersEffect: -3, effectsDescription: "", description: "A group of followers begins to follow an alternative path.", imageName: "fight", type: .heresy, rarity: 5),
        Card(name: "New Name", faithCost: 0, heresyCost: -3, followersEffect: -9, effectsDescription: "", description: "A precisely cast doubt is more lethal than a blade. The leader’s prestige falters, and the faithful scatter.", imageName: "gossip", type: .heresy, rarity: 5),
        Card(name: "Mirror of Dissent", faithCost: 0, heresyCost: -3, followersEffect: -9, effectsDescription: "", description: "The heretic uses an enchanted mirror to reveal hidden truths to the faithful.", imageName: "mirror", type: .heresy, rarity: 5),
        Card(name: "Tear of Ashes", faithCost: 0, heresyCost: -3, followersEffect: -9, effectsDescription: "", description: "A cursed artifact makes the rituals feel hollow and meaningless.", imageName: "blood", type: .heresy, rarity: 5),
        Card(name: "Torn Manuscript", faithCost: 0, heresyCost: 3, followersEffect: 0, effectsDescription: "", description: "Fragments of a forbidden text circulate among the weakest of the faithful.", imageName: "writing", type: .heresy, rarity: 5),
        Card(name: "Profane Mirror", faithCost: 0, heresyCost: -3, followersEffect: -6, effectsDescription: "", description: "An artifact reveals the cultists’ hypocrisy to the eyes of the faithful.", imageName: "writing", type: .heresy, rarity: 5),
        Card(name: "Secret Ritual", faithCost: 0, heresyCost: 6, followersEffect: -12, effectsDescription: "", description: "In muffled chants and hidden circles, forbidden ceremonies are conducted. Few return… but power makes itself known.", imageName: "writing", type: .heresy, rarity: 1)
    ]

    let assassinationCard = Card(name: "Assassination", faithCost: 0, heresyCost: -10, followersEffect: 0, effectsDescription: "This card eliminates one of the players ", description: "During the night, the leader is found with their robe soaked and eyes staring into nothingness. No alarm was heard. The strike was precise — and final.", imageName: "blood", type: .assassination, rarity: 10)
    
    var specialCards: [SpecificCard] = []
}
