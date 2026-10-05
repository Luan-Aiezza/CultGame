# Cult Game

A social deduction party game for **Apple TV and iPhone**. Cultists are trying to expand their cult in the forest while a heretic tries to end it. The Apple TV hosts the match and shows the shared board, and each player uses their own iPhone as a private controller.

## How to play

Matches are for **5 to 7 players**. Each player picks an animal character (fox, panda, bunny, tiger, deer, pig or wolf) and is secretly assigned a role: **cultist** or **heretic**. Each round goes through these phases:

1. **Pairing:** iPhones join the match hosted on the Apple TV.
2. **Role selection:** each player sees their secret role.
3. **Card play:** players play cards from their hand. Cultist and common cards spend **faith** and change the number of **followers**. The heretic also has **heresy** cards that damage the cult, including an assassination card.
4. **Discussion:** everyone debates who the heretic might be, on a timer.
5. **Elimination:** players vote, and can skip their vote, to eliminate a suspect.
6. **Results:** the Apple TV reveals who was eliminated, then play continues until someone wins.

The game ends with one of four outcomes:

- **Cultists win** when the followers reach the maximum, or when the heretic is eliminated.
- **The heretic wins** when the followers drop to zero, or when the active heretics are at least as many as the active cultists.

## Features

- **Two apps in one project:** an iOS controller and a tvOS host that share game logic.
- **Local multiplayer** between the iPhones and the Apple TV using `MultipeerConnectivity` with encrypted sessions.
- **Card system** with common, cultist and heresy decks, costs, effects and rarity, and a swipeable card carousel.
- **Phase-driven flow** synced across all devices through a shared `GameViewModel`.
- **Timers** for discussion and voting, run on the Apple TV.
- **Audio and visuals:** soundtrack and sound effects, custom fonts and illustrated cards.

## Architecture

| Folder | Contents |
| --- | --- |
| `Shared/Models` | Cards, deck, players, roles, game phases and network messages |
| `Shared/ViewModels` | `GameViewModel`, `MultiplayerManager`, card distribution and timers |
| `Shared/Extensions` | Game logic split by concern: phases, cards, elimination, victory and multiplayer sync |
| `Cult_Game_iOS/Views` | iPhone flow, one folder per phase |
| `Cult_Game_tvOS` | Apple TV flow, components and game timer manager |
| `Audio`, `Resources` | Music, effects, fonts and managers |

## Tech stack

![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=swift&logoColor=white) ![SwiftUI](https://img.shields.io/badge/SwiftUI-007AFF?style=for-the-badge&logo=swift&logoColor=white) ![tvOS](https://img.shields.io/badge/tvOS-000000?style=for-the-badge&logo=apple&logoColor=white) ![MultipeerConnectivity](https://img.shields.io/badge/MultipeerConnectivity-5856D6?style=for-the-badge&logo=apple&logoColor=white) ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=for-the-badge&logo=xcode&logoColor=white)

## Running the project

Requirements: Xcode, an Apple TV (or tvOS simulator) and at least five iPhones, all on the same network. The iOS target needs **iOS 17.6 or later** and the tvOS target needs **tvOS 17.6 or later**.

1. Clone the repository:
   ```bash
   git clone https://github.com/Luan-Aiezza/Cult_Game.git
   ```
2. Open `Cult_Game_iOS/Cult_Game_iOS.xcodeproj` in Xcode.
3. Run the **tvOS** scheme on the Apple TV to host a match.
4. Run the **iOS** scheme on each iPhone and join the match.

## Team

Built by Luan Aiezza, Jessica Rodrigues, Samuel Coelho, Grecia Rivera, Mariane Oliveira and Anne Auzier.
