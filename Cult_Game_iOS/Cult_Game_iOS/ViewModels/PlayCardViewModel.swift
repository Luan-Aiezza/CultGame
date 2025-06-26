//
//  PlayCardViewModel.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 21/05/25.
//

import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

class PlayCardViewModel: ObservableObject {
    
    @Published var cards: [Card] = []
    @Published var snappedItem: Double = 0.0
    @Published var draggingItem: Double = 0.0
    @Published var activeIndex: Int = 0
    @Published var showBlockMessage: Bool = false
    @Published var selectedCard: Card? = nil
    @Published var zoomedCard: Card? = nil
    @Published var showZoomedCard: Bool = false
    @Published var hand: [Card] = []
    @Published var stringShow = "The cult does not have enough faith points to choose a card"
    @Published var skippedRound: Bool = false
    @Published var playedCard: Bool = false
    @Published var showMurderView = false
    
    var vm: GameViewModel?
    var multiplayerManager = MultiplayerManager.shared
    
    func settings(vm: GameViewModel) {
        self.vm = vm
        self.hand = vm.player.hand
    }
    
    func updateMessage() {
        if let vm = self.vm {
            if vm.player.role == .cultist {
                stringShow = "Your cult does not have enough faith to play this card."
            } else {
                stringShow = "You do not have enough heresy to play this card."
            }
        }
    }
    
    func skipRound() {
        guard !playedCard, selectedCard == nil else { return }
        if let vm = self.vm {
            vm.skipCard()
        }
        skippedRound = true
        stringShow = "You skipped this round!"
        showBlockMessage = true
    }
    
    func playSelectedCard() {
        print("entrou em play selectedcard")
        if let vm = self.vm {
            guard let selected = selectedCard,
                  let cardToPlay = vm.player.hand.first(where: { $0.id == selected.id }),
                  !skippedRound else { return }
            
            vm.playCard(cardToPlay)
            stringShow = "You already played a card!"
            showBlockMessage = true
            playedCard = true
            
            if cardToPlay.type == .assassination {
                toggleMurderView()
            }
            
            vm.destroyUsedCard()
        }
    }
    
    func toggleMurderView() {
        showMurderView.toggle()
    }

    
    func zoomCard(_ card: Card){
        zoomedCard = card
        showZoomedCard = true
    }
    
    func selectCard(_ card: Card) {
        if selectedCard == nil {
            selectedCard = card
            hand.removeAll { $0 == card }
        }
    }
    
    func returnSelectedCard() {
        if let card = selectedCard, !playedCard {
            hand.append(card)
            selectedCard = nil
        }
    }
    
    func dropBackCard(_ card: Card) {
        hand.append(card)
        selectedCard = nil
    }
    
    func distance(_ item: Int) -> Double {
        guard cards.count > 0 else { return 0 }
        return (draggingItem - Double(item)).remainder(dividingBy: Double(cards.count))
    }
    
    func offset(_ item: Int, xDistance: Int = 120) -> Double {
        let angle = Double.pi * 2 / Double(cards.count) * distance(item)
        return sin(angle) * Double(xDistance)
    }
    
    func isCardBlocked(_ card: Card) -> Bool {
        switch card.type {
        case .common, .cultist:
            return (card.faithCost < 0 && multiplayerManager.globalState.sharedFaithPoints < abs(card.faithCost)) || skippedRound
        case .heresy, .assassination:
            return (card.heresyCost < 0 && multiplayerManager.globalState.heresyPoints < abs(card.heresyCost)) || skippedRound
        case .empty:
            return false
        }
    }
    
    func updateBlockMessage() {
        let centerIndex = Int(snappedItem).positiveMod(cards.count)
        if cards.indices.contains(centerIndex) {
            let centerCard = cards[centerIndex]
            showBlockMessage = isCardBlocked(centerCard)
        } else {
            showBlockMessage = false
        }
    }
    
    func onDragChanged(_ value: DragGesture.Value) {
        draggingItem = snappedItem + value.translation.width / 100
    }
    
    func onDragEnded(_ value: DragGesture.Value) {
        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
        if cards.count > 0 {
            draggingItem = round(draggingItem).remainder(dividingBy: Double(cards.count))
        }
        snappedItem = draggingItem
        activeIndex = cards.count + Int(draggingItem)
        if activeIndex > cards.count || Int(draggingItem) >= 0 {
            activeIndex = Int(draggingItem)
        }
        updateBlockMessage()
    }
    
    func resetCarousel() {
        snappedItem = 0
        draggingItem = 0
        activeIndex = 0
        updateBlockMessage()
    }
}
