//
//  PlayCardView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 21/05/25.
//

import SwiftUI
import SpriteKit

struct SelectCard: View {
    @Binding var selectedCard: Card?
    @Binding var zoomedCard: Card?
    @Binding var showZoomedCard : Bool
    
    var body: some View {
        if let card = selectedCard {
            CardView(card: card)
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
                .draggable(card)
                .onTapGesture {
                    withAnimation {
                        zoomedCard = card
                        showZoomedCard = true
                    }
                }
        } else {
            Image("selectCard")
                .resizable()
                .scaledToFit()
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
        }
    }
}

struct PlayCardView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var pvm = PlayCardViewModel()
    @State var selectedCard: Card? = nil
    @State var hand: [Card] = []
    @State var zoomedCard: Card? = nil
    @State var showZoomedCard = false
    @State var showBlockMessage = false
    @State var stringShow = "The cult does not have enough faith points to choose a card"
    @State var skippedRound: Bool = false
    @State var playedCard: Bool = false
    @State private var showMurderView = false
    @State private var showFollowTvView = false
    
    @ViewBuilder
    var destinationView: some View {
        if let outcome = vm.gameOutcome,
           let role = vm.player.role {
            VictoryScreenView(role: role, outcome: outcome)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if let card = zoomedCard, showZoomedCard {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    CardView(card: card)
                        .frame(width: 350, height: 490)
                        .shadow(radius: 10)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                showZoomedCard = false
                            }
                        }
                        .zIndex(2)
                }
                
                if showBlockMessage && !showZoomedCard {
                    blockMessageView(show: $stringShow)
                        .zIndex(4)
                }
                
                // Fundo com a cena do SpriteKit
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                VStack {
                    SelectCard(selectedCard: $selectedCard, zoomedCard: $zoomedCard, showZoomedCard: $showZoomedCard)
                        .padding(.vertical, 50)
                        .dropDestination(for: Card.self) { items, location in
                            if let card = items.first {
                                if selectedCard == nil {
                                    selectedCard = card
                                    hand.removeAll { $0 == card }
                                    return true
                                }
                            }
                            return false
                        }
                        .onTapGesture {
                            if let card = selectedCard {
                                if !playedCard {
                                    hand.append(card)
                                    selectedCard = nil
                                }
                            }
                        }
                        .transition(.slide)
                    if selectedCard != nil {
                        HStack(spacing: 20) {
                            ForEach(hand, id: \.id) { card in
                                CardView(card: card)
                                    .frame(width: 154, height: 216)
                                    .draggable(card)
                                    .overlay {
                                        if playedCard {
                                            ZStack {
                                                Color.black.opacity(0.6)
                                                    .cornerRadius(12)
                                                Image("block")
                                            }
                                        }
                                    }
                            }
                        }
                        .dropDestination(for: Card.self) { items, location in
                            if let card = selectedCard {
                                hand.append(card)
                                selectedCard = nil
                                return true
                            }
                            return false
                        }
                    } else {
                        CardCarouselView(
                            selectedCard: $selectedCard,
                            zoomedCard: $zoomedCard,
                            showZoomedCard: $showZoomedCard,
                            showBlockMessage: $showBlockMessage,
                            cards: $hand,
                            skippedRound: $skippedRound
                        )
                    }
                    
                    HStack(spacing: 50) {
                        Button {
                            if !playedCard && selectedCard == nil {
                                vm.skipCard()
                                skippedRound = true
                                stringShow = "You skiped this round!"
                                showBlockMessage = true
                            }
                        } label: {
                            ZStack {
                                Image("CardDoneButton")
                                    .resizable()
                                    .frame(width:124,height:48)
                            }
                        }
                        
                        Button {
                            if let selectedCard = selectedCard,
                               let cardToPlay = vm.player.hand.first(where: { $0.id == selectedCard.id }) {
                                if !skippedRound {
                                    vm.playCard(cardToPlay)
                                    stringShow = "You already played a card!"
                                    showBlockMessage = true
                                    playedCard = true
                                    
                                    if cardToPlay.type == .assassination {
                                        showMurderView = true
                                    }
                                }
                            }
                        } label: {
                            Image("cardViewButton")
                                .resizable()
                                .frame(width:124,height:48)
                        }
                    }
                    .frame(maxWidth: 500)
                    .padding()
                    if showFollowTvView {
                        FollowTvView()
                            .transition(.opacity)
                            .zIndex(5)
                    }
                }
                
                NavigationLink(
                    destination: destinationView,
                    isActive: Binding(
                        get: { vm.gameOutcome != nil },
                        set: { _ in }
                    )
                ) {
                    EmptyView()
                }
                .fullScreenCover(isPresented: $showMurderView) {
                    MurderView()
                }
                
            }
        }
        .onReceive(multiplayerManager.$currentPhase) { newPhase in
            // Impede que a phase visível vá para .discussion automaticamente
            
            if newPhase == .discussion {
                // Mantenha a fase visível como está
//                print("Tentativa de ir para .discussion ignorada")
            }
        }
        .onAppear {
            self.hand = vm.player.hand
            vm.handlePhaseChange()
            
            if vm.player.role == .cultist {
                self.stringShow = "Your cult does not have enough faith to play this card."
            } else {
                self.stringShow = "You do not have enough heresy to play this card."
            }
        }
        .onChange(of: multiplayerManager.currentPhase) { oldValue, newValue in
            
            if newValue == .discussion {
                if !skippedRound && !playedCard {
                    vm.skipCard()
                    skippedRound = true
                   
                    showFollowTvView = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showFollowTvView = false
                        stringShow = "Blocked cards, time to discuss!"
                        showBlockMessage = true
                    }
                }
            }
        }
    }
}

#Preview(body: {
    PlayCardView()
        .environmentObject(GameViewModel())
})
