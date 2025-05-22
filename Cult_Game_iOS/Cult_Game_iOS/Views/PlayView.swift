//
//  PlayView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 20/05/25.
//

import SwiftUI

struct PlayView: View {
    @EnvironmentObject var vm: GameViewModel
    
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
                
                NavigationLink {
                    GameView()
                } label: {
                    Text("Play")
                        .font(.custom("VinerHandITC", size: 40))
                        .foregroundStyle(Color.title)
                        
                }
            }
        }
    }
}

#Preview {
    PlayView()
        .environment(GameViewModel())
}
