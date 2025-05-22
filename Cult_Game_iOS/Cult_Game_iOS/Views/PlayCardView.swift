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
    @State private var selectedCard: Card? = nil
    
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
                                        content
                                            .scaleEffect(phase.isIdentity ? 1 : 0.8)
                                    }
                            }
                        }
                    }
                    Button("Testar MurderView") {
                        pvm.isShowingMurderView.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 20)
                }
                MurderView()
                    .environmentObject(pvm)
                    .opacity(pvm.isShowingMurderView ? 1 : 0)
                    .animation(.easeInOut, value: pvm.isShowingMurderView)
                
            }
            
        }
    }
}


//#Preview {
//    PlayCardView( pvm: <#PlayCardViewModel#>)
//        .environment(GameViewModel())
//}
