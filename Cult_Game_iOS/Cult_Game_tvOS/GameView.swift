//
//  GameView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var vm: GameViewModel
    
    var body: some View {
        ZStack {
            
            switch multiplayerManager.currentPhase {
            case .pairing:
                HostGameView()
                    .environmentObject(vm)
            case .roleSelection:
                StoryView()
                    .environmentObject(vm)
            case .cardPlay:
                GameStatusView()
                    .environmentObject(vm)
                    .ignoresSafeArea(.all)
            case .discussion:
                DiscussionView()
                    .environmentObject(vm)
                    .ignoresSafeArea(.all)
            case .elimination:
                VotingView()
                    .environmentObject(vm)
                    .ignoresSafeArea(.all)
            case .eliminationResults:
                VotingResultView()
                    .environmentObject(vm)
                    .ignoresSafeArea(.all)
            case .victory(_):
                if let outcome = vm.gameOutcome {
                    VictoryTvView(outcome: outcome)
                        .environmentObject(vm)
                        .ignoresSafeArea(.all)
                }
            }
        }
    }
}
