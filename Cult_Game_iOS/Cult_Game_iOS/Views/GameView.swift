//
//  GameView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        ZStack {
            
            if vm.player.state == .inactive {
                VStack {
                    Text("você foi eliminado")
                }
            } else {
                switch multiplayerManager.currentPhase {
                case .pairing:
                    WaitingView()
                case .roleSelection:
                    StoryView()
                case .cardPlay:
                    PlayCardView()
                case .discussion:
                    DiscussionView()
                case .elimination:
                    EliminationView()
                case .eliminationResults:
                    EliminationResultsView()
                case.victory:
                    EliminationResultsView()
                }
            }
        }.onAppear {
            multiplayerManager.joinSession()

            NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                if let role = notification.object as? PlayerRole {
                    vm.selectRole(role)
                }
            }
            
            NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
                if let role = notification.object as? Character {
                    vm.assignCharacter(role)
                }
            }
            
            NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
                if let character = notification.object as? Character {
                    // Atualize a UI com o personagem recebido
                    print("🎨 Recebi meu personagem: \(character)")
                }
            }

        }
    }
}
