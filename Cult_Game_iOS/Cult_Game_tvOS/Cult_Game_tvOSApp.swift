//
//  Cult_Game_tvOSApp.swift
//  Cult_Game_tvOS
//
//  Created by Luan Aiezza on 05/05/25.
//

import SwiftUI

@main
struct Cult_Game_tvOSApp: App {
    var body: some Scene {
        WindowGroup {
            TvTransitionTextsView()
            
                .ignoresSafeArea()
        }
    }
}
