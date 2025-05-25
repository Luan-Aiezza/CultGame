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
                if let outcome = vm.gameOutcome {
                    VictoryTvView(outcome: outcome)
                }
            }
        }// on appear se precisar
    }
}
