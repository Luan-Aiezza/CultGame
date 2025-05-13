//
//  RoleView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 12/05/25.
//

import SwiftUI

struct RoleView: View {
    
    @ObservedObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        ZStack {
            
            Image("background_001")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            
            VStack{
                Text("You are a \(viewModel.role?.rawValue ?? "Unknown")!")
                    .font(.custom("VinerHandITC", size: 45))

            }
        }
    }
}

#Preview {
    RoleView()
}
