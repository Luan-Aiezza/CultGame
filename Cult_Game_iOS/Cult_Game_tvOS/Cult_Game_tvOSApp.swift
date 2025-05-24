//
//  Cult_Game_tvOSApp.swift
//  Cult_Game_tvOS
//
//  Created by Luan Aiezza on 05/05/25.
//

import SwiftUI
import SpriteKit

@main
struct Cult_Game_tvOSApp: App {
    
    init(){
        FontManager.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TvTransitionTextsView(type: .introSequence, isFirstRound: true) {
                print("Sequência finalizada!")
            }
            .ignoresSafeArea()
        }
    }
}
