//
//  PlayView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 20/05/25.
//

import SwiftUI
import SpriteKit

struct StoryView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var fadeInOut : Bool = false
    @State private var changeView : Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }

                
                VStack {
                    TvTransitionTextsView(type: .introSequence, isFirstRound: true)
                }
                
                Color.black
                    .opacity(fadeInOut ? 0 : 1)
                    .ignoresSafeArea()
                    .animation(.easeIn(duration: 2), value: fadeInOut)
                    
            } .onAppear {
                
                fadeInOut =  true
                DispatchQueue.main.asyncAfter(deadline: .now() + 12.0) {
                    fadeInOut = false
                    changeView = true
                    multiplayerManager.sendGamePhase(.cardPlay)
                }
            }
            
            .fullScreenCover(isPresented: $changeView) {
                GameStatusView()
            }
        }
    }
}
