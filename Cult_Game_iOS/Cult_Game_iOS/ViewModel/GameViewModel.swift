import SwiftUI
import Foundation
import GameKit

class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = []
    @Published var usedCard: Card?
    @Published var points: Int = 10
    @Published var followers: Int = 50
    @Published var role: PlayerRole? = nil
    
    
    //RELACIONADO AO HOST
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedData(_:)), name: .didReceiveGameData, object: nil)
    }
    
    @objc func handleReceivedData(_ notification: Notification) {
        guard let data = notification.object as? Data else { return }
        // Decodifique e processe os dados
        if let update = try? JSONDecoder().decode(GameUpdate.self, from: data) {
            self.points = update.sharedFaithPoints
            self.followers = update.sharedFollowers
        }
    }
    /* HOST */
    
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
            playerHand.append(assassinationCard) // carta permanente
        default: break
        }
    }
    
    func playCard(_ card: Card) {
        guard points >= card.faithCost else { return }
        points -= card.faithCost
        followers += card.followersEffect

        if card.type != .assassination {
            usedCard = card
            playerHand.removeAll { $0.id == card.id }
        }

        // Envia ação ao host
        let action = CardPlayAction(card: card, playerRole: role ?? .cultist)
        MultiplayerManager.shared.send(action)
        
    }
    
    func processCardAction(_ action: CardPlayAction) {
        // Atualiza o estado compartilhado
        if action.playerRole == .cultist {
            points -= action.card.faithCost
            followers += action.card.followersEffect
        } else if action.playerRole == .heretic {
            // lógica do herege
        }

        // Broadcast update para todos
        let update = GameUpdate(sharedFaithPoints: points, sharedFollowers: followers)
        if let data = try? JSONEncoder().encode(update) {
            MultiplayerManager.shared.sendDataToAllPlayers(data)
        }
    }

    func replenishCard() {
        if let card = usedCard {
            playerHand.append(card)
            usedCard = nil
        }
    }
    
    //HOST
    func receiveData(_ data: Data, from player: GKPlayer) {
        if let state = try? JSONDecoder().decode(GlobalGameState.self, from: data) {
            DispatchQueue.main.async {
//                self.globalState = state
            }
        } else if let action = try? JSONDecoder().decode(CardPlayAction.self, from: data) {
            // Ação do jogador (já tratada no host)
        }
    }
}
