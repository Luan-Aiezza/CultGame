//  GameView.swift
//  Cult_Game_iOS
//  Created by Jessica Rodrigues on 22/05/25.

import SwiftUI

#warning("A struct está ferindo o príncipio de responsabilidade única do SOLID, pois está tratando dois casos diferentes: GamePhase + JoinPlayers. Sugestão: Separar em duas views.")

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
                #warning("Nested(uma estrutura dentro da outra, tipo função dentro de função) nem sempre é uma boa prática em termos de legibilidade. Sugestão: if let outcome = vm.gameOutcome, let role = vm.player.role {}")
                if let outcome = vm.gameOutcome,let role = vm.player.role  {
                        VictoryScreenView(role: role, outcome: outcome)
                            .environmentObject(vm)
//                    }
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
            
#warning("O uso direto da UIApplication na view, fere os princípios de responsabilidade única. Essa estrutura deveria estar na ViewModel ou em um serviço.")
            UIApplication.shared.isIdleTimerDisabled = true
            
            
#warning("Cuidado com vazamento de memória, vários observadores estão sendo adicionados, mas nenhum é removido quando a cena sai. Sugestão: Remover com 'removeObserver' no onDisappear, por exemplo.")
            NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                if let role = notification.object as? PlayerRole {
                    vm.selectRole(role)
                }
            }
            
#warning("didReceiveCharacter está sendo chamado duas vezes, o que pode levar a múltiplas execuções desnecessárias.")
            NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
                if let role = notification.object as? Character {
                    vm.assignCharacter(role)
                }
            }
            
//            NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
//                if let character = notification.object as? Character {
//                    // Atualize a UI com o personagem recebido
//                    print("🎨 Recebi meu personagem: \(character)")
//                }
//            }
            
        }
    
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
}
}
