
//  FollowTvView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 26/05/25.
//

import SwiftUI

struct FollowTvViewEnd: View {
    
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        Color.black.opacity(0.85)
            .ignoresSafeArea()
            .transition(.opacity)
            .zIndex(1)
        
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                Button(action: {
                    viewModel.resetGame()
                    MultiplayerManager.shared.disconnectAll()
                    multiplayerManager.currentPhase = .pairing
                }) {
                    Image("Exit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .padding(.trailing, 32)
                .padding(.top, 44)
            }
            
            Spacer()
            
            Image("tv_frame")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("End game!\nClose the game on iPhone ")
                .font(.custom("VinerHandITC", size: 30))
                .foregroundStyle(Color.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
            Spacer()
            
        }
        .padding(.horizontal, 80)
        .zIndex(2)
    }
}

#Preview {
    FollowTvView()
}
