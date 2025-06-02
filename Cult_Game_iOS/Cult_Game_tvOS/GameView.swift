//
//  GameView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var vm: GameViewModel
    
    var body: some View {
        ZStack {
            switch multiplayerManager.currentPhase {
            case .pairing:
                HostGameView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .roleSelection:
                StoryView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .cardPlay:
                GameStatusView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .discussion:
                DiscussionView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .elimination:
                VotingView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .eliminationResults:
                VotingResultView()
                    .environmentObject(vm)
                    .ignoresSafeArea()
            case .victory(_):
                if let outcome = vm.gameOutcome {
                    VictoryTvView(outcome: outcome)
                        .environmentObject(vm)
                        .ignoresSafeArea()
                }
            }
        }
    }
}
