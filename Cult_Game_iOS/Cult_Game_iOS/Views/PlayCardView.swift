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
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()

                VStack {
                    SelectCard(selectedCard: $selectedCard)
                        .dropDestination(for: Card.self) { items, location in
                            if let card = items.first {
                                selectedCard = card
                                return true
                            }
                            return false
                        }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(vm.player.hand) { card in
                                CardView(card: card)
                                    .frame(width: 154, height: 216)
                                    .draggable(card)
                                    .onTapGesture {
                                        selectedCard = card
                                    }
                                    .scrollTransition { content, phase in
                                        content.scaleEffect(phase.isIdentity ? 1 : 0.8)
                                    }
                            }
                        }
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
            }
        }
    }
}



#Preview {
    PlayCardView()
        .environment(GameViewModel())
}
