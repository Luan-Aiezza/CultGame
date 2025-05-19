//
//  Cult_Game_iOSApp.swift
//  Cult_Game_iOS
//
//  Created by Luan Aiezza on 01/05/25.
//

import SwiftUI

@main
struct Cult_Game_iOSApp: App {
    
    init() {
        FontManager.registerFonts()
        
        for family in UIFont.familyNames {
            print("Family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("  Font: \(name)")
            }
        }

    }
    
    
    var body: some Scene {
        WindowGroup {
            RoleView()
        }
    }
}
