//  SelectCardView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 25/06/25.
//

import SwiftUI

struct SelectCard: View {
    
    @EnvironmentObject var viewModel: PlayCardViewModel
    
    var body: some View {
        if let card = viewModel.selectedCard {
            CardView(card: card)
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
                .draggable(card)
                .onTapGesture {
                    withAnimation {
                        viewModel.zoomCard(card)
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
