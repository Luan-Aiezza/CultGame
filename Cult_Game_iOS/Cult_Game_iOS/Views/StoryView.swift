//
//  PlayView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 20/05/25.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var fadeInOut : Bool = false
    @State private var changeView : Bool = false
    
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
                    Text("A new day starts on the village and you are...")
                        .font(.custom("Almendra-Regular", size: 35))
                        .foregroundStyle(Color.title)
                        .multilineTextAlignment(.center)
                }
                
                Color.black
                    .opacity(fadeInOut ? 0 : 1)
                    .ignoresSafeArea()
                    .animation(.easeIn(duration: 2), value: fadeInOut)
                    
            } .onAppear {
                fadeInOut =  true
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    fadeInOut = false
                    changeView = true
                }
            }
            
            .fullScreenCover(isPresented: $changeView) {
                RoleView()
            }
        }
    }
}

#Preview {
    StoryView()
        .environment(GameViewModel())
}
