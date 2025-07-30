
//  FollowTvView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 26/05/25.
//

import SwiftUI

struct FollowTvViewEnd: View {

    var body: some View {
        Color.black.opacity(0.85)
            .ignoresSafeArea()
            .transition(.opacity)
            .zIndex(1)
        
        VStack(spacing: 20) {
            Image("tv_frame")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
            
            Text("End game!\nClose the game on iPhone ")
                .font(.custom("VinerHandITC", size: 30))
                .foregroundStyle(Color.title)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
            
        }
        .padding(.horizontal, 80)
        .zIndex(2)
    }
}

#Preview {
    FollowTvView()
}
