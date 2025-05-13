//
//  FontManager.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 13/05/25.
//

import Foundation
import SwiftUI

public struct FontManager {
    public static func registerFonts() {
        registerFont(bundle: Bundle.main , fontName: "Almendra-Regular", fontExtension: "ttf") //change according to your ext.
        registerFont(bundle: Bundle.main , fontName: "VinerHandITC", fontExtension: "TTF") //change according to your ext.
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
              let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }
        
        var error: Unmanaged<CFError>?
        
        CTFontManagerRegisterGraphicsFont(font, &error)
    }
}
