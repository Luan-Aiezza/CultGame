//
//  Cult_Game_iOSApp.swift
//  Cult_Game_iOS
//
//  Created by Luan Aiezza on 01/05/25.
//

import SwiftUI

@main
struct Cult_Game_iOSApp: App {
    @StateObject var vm = GameViewModel()
    
    init(){
        FontManager.registerFonts()
    }
    
    var body: some Scene {
    
        WindowGroup {
            MainViewiOS()
                .environmentObject(vm)
        }
    }
}


//var body: some View {
//    ZStack {
//        switch visiblePhase {
//            case .pairing:
//                WaitingView()
//            case .roleSelection:
//                StoryView()
//            case .cardPlay:
//                PlayCardView()
//            case .discussion:
//                DiscussionView()
//            case .elimination:
//                EliminationView()
//            case .eliminationResults:
//                EliminationResultsView()
//            case.victory(_):
//                if let outcome = vm.gameOutcome {
//                    if let role = vm.player.role {
//                        VictoryScreenView(role: role, outcome: outcome)
//                        .environmentObject(vm)
//                }
//            }
//        }
//    }
//    .onReceive(mult
