//
//  PlayCardView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 21/05/25.
//

import SwiftUI

struct SelectCard: View {
    @Binding var selectedCard: Card?
    
    var body: some View {
        if let card = selectedCard {
            CardView(card: card)
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
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
    @ObservedObject var pvm = PlayCardViewModel()
    @State var selectedCard: Card? = nil
    @State var hand: [Card] = []
    @State var zoomedCard: Card? = nil
    @State var showZoomedCard = false
    @State var showBlockMessage = false
    @State var stringShow = "O culto não tem pontos de fé suficientes para escolher uma carta"
    @State var skippedRound: Bool = false
    @State var playedCard: Bool = false
    
    @State private var selectedCard: Card? = nil

    @ViewBuilder
    var destinationView: some View {
        if let outcome = vm.gameOutcome,
           let role = vm.player.role {
            VictoryScreenView(role: role, outcome: outcome, viewModel: vm)
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
                
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()

                VStack {
                    
                    
                    
                    SelectCard(selectedCard: $selectedCard)
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
                                stringShow = "Você pulou esta rodada."
                                showBlockMessage = true
                            }
                        } label: {
                            Image("cardViewButton")
                        }
                        
                        Button {
                            if let selectedCard = selectedCard,
                               let cardToPlay = vm.player.hand.first(where: { $0.id == selectedCard.id }) {
                                if !skippedRound {
                                    vm.playCard(cardToPlay)
                                    stringShow = "Você já jogou uma carta."
                                    showBlockMessage = true
                                    playedCard = true
                                }
                            }
                        } label: {
                            Image("cardViewButton")
                        }
                    }
                    .padding()
                    
                    MurderView()
                        .environmentObject(pvm)
                        .opacity(pvm.isShowingMurderView ? 1 : 0)
                        .animation(.easeInOut, value: pvm.isShowingMurderView)
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
    }
}



#Preview {
    PlayCardView(pvm: PlayCardViewModel())
        .environment(GameViewModel())
}
