//
//  GameView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var multiplayerManager: MultiplayerManager
    
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            switch multiplayerManager.currentPhase {
            case .pairing:
                HostGameView()
            case .roleSelection:
                StoryView()
            case .cardPlay:
                GameStatusView()
            case .discussion:
                DiscussionView()
            case .elimination:
                VotingView()
            case .eliminationResults:
                VotingResultView()
            case .victory(_):
                VictoryTvView(outcome: .cultistVictoryElimination, viewModel: GameViewModel())
            }
        }// on appear se precisar
    }
}

#Preview {
    GameView()
        .environmentObject(MultiplayerManager.shared)
        .environmentObject(GameViewModel())
}
