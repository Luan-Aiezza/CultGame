//  GameView.swift
//  Cult_Game_iOS
//  Created by Jessica Rodrigues on 22/05/25.

import SwiftUI

struct GameView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State var visiblePhase: GamePhase = .pairing
    
    var body: some View {
        ZStack {
            switch visiblePhase {
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
                case.victory(_):
                    if let outcome = vm.gameOutcome {
                        if let role = vm.player.role {
                            VictoryScreenView(role: role, outcome: outcome)
                            .environmentObject(vm)
                    }
                }
            }
        }
        .onReceive(multiplayerManager.$currentPhase) { newPhase in
            // Impede que a phase visível vá para .discussion automaticamente
            if vm.player.state == .inactive {
                return
            }
            if newPhase == .discussion {
                // Mantenha a fase visível como está
                print("Tentativa de ir para .discussion ignorada")
            } else {
                visiblePhase = newPhase
            }
        }
        .onAppear {
            multiplayerManager.joinSession()

            UIApplication.shared.isIdleTimerDisabled = true
                

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
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }
}
