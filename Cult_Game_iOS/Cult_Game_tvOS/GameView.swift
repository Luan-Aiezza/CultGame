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
            case .roleSelection:
                StoryView()
                    .environmentObject(vm)
            case .cardPlay:
                GameStatusView()
                    .environmentObject(vm)
            case .discussion:
                DiscussionView()
                    .environmentObject(vm)
            case .elimination:
                VotingView()
                    .environmentObject(vm)
            case .eliminationResults:
                VotingResultView()
                    .environmentObject(vm)
            case .victory(_):
                if let outcome = vm.gameOutcome {
                    VictoryTvView(outcome: outcome)
                        .environmentObject(vm)
                }
            }
        }
    }
}
