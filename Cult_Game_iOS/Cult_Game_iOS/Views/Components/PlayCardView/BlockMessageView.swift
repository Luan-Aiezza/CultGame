//
//  BlockMessageView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 25/06/25.
//

import Foundation
import SwiftUI

struct blockMessageView : View {
    
    @Binding var show : String
    
    var body: some View {
        ZStack {
            Image("tip_001")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
            Text(show)
                .frame(width: 240)
                .font(.custom("Almendra-Regular", size: 16))
                .foregroundColor(Color.title)
                .padding(.horizontal, 8)
                .padding(.bottom, 15)
                .multilineTextAlignment(.center)
        }
    }
}
