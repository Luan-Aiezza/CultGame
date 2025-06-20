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
            EliminationView()
                .environmentObject(vm)

        }
    }
}
