
//  FollowTvView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 26/05/25.
//

import SwiftUI

struct FollowTvViewDead: View {
    
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        Color.black.opacity(1)
            .ignoresSafeArea()
            .transition(.opacity)
            .zIndex(4)
        
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                Button(action: {
                    multiplayerManager.disconnect()
                    multiplayerManager.currentPhase = .pairing
                }) {
                    Image("Exit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .padding(.trailing, 20)
                .padding(.top, 44)
            }
            
            Spacer()
            
            Image("tv_frame")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("You have been eliminated,\n wait for the game to end!")
                .font(.custom("VinerHandITC", size: 30))
                .foregroundStyle(Color.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
        .zIndex(5)
    }
}

#Preview {
    FollowTvView()
}
