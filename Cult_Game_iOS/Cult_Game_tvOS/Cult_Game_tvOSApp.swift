//
//  Cult_Game_tvOSApp.swift
//  Cult_Game_tvOS
//
//  Created by Luan Aiezza on 05/05/25.
//

import SwiftUI

@main
struct Cult_Game_tvOSApp: App {
    @StateObject var multiplayerManager = MultiplayerManager.shared
    @StateObject var gameViewModel = GameViewModel()
    
    init(){
        FontManager.registerFonts()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            HomeScreenView()
                .environmentObject(multiplayerManager)
                .environmentObject(gameViewModel)
                .ignoresSafeArea()
        }
    }
}
