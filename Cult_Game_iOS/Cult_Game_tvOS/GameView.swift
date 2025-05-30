//
//  GameView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var vm: GameViewModel = GameViewModel()
    
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
                TvTransitionTextsView(type: .middleSequence, isFirstRound: true)
                    .environmentObject(vm)
//                VotingView()
            case .eliminationResults:
                VotingResultView()
                    .environmentObject(vm)
            case .victory(_):
                if let outcome = vm.gameOutcome {
                    VictoryTvView(outcome: outcome)
                }
            }
        }// on appear se precisar
    }
}
