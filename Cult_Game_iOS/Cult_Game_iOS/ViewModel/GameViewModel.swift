import SwiftUI
import Foundation
import MultipeerConnectivity

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var role: PlayerRole? = nil
    
    private let multiplayerManager = MultiplayerManager.shared
    private var peerID: MCPeerID {
        multiplayerManager.myPeerID
    }

    var isHost: Bool {
        multiplayerManager.isHosting
    }

    var points: Int {
        get {
            guard let role else { return 0 }
            if role == .cultist {
                return multiplayerManager.globalState.sharedFaithPoints
            } else {
                return multiplayerManager.globalState.heresyPoints[peerID.displayName, default: 0]
            }
        }
    }

    var followers: Int {
        multiplayerManager.globalState.followers
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncState), name: .didReceiveGameData, object: nil)
    }

    @objc func syncState() {
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }

    func selectRole(_ selectedRole: PlayerRole) {
        self.role = selectedRole
        receiveInitialCards()
    }

    func receiveInitialCards() {
        playerHand.removeAll()

        switch role {
        case .cultist:
            playerHand.append(contentsOf: commonCards.shuffled().prefix(2))
            playerHand.append(cultistCards.randomElement()!)
        case .heretic:
            playerHand.append(contentsOf: commonCards.shuffled().prefix(2))
            playerHand.append(contentsOf: heresyCards.shuffled().prefix(2))
            playerHand.append(assassinationCard)
        default: break
        }
    }

    func playCard(_ card: Card) {
        guard points >= card.faithCost else { return }

        let action = CardPlayAction(playerID: peerID.displayName, card: card, playerRole: role!)

        if isHost {
            multiplayerManager.handleReceived(try! JSONEncoder().encode(action), from: peerID)
        } else {
            multiplayerManager.send(action)
        }

        if card.type != .assassination {
            usedCard = card
            playerHand.removeAll { $0.id == card.id }
        }
    }

    func replenishCard() {
        if let card = usedCard {
            playerHand.append(card)
            usedCard = nil
        }
    }
}
