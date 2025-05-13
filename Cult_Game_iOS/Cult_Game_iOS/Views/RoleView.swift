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
                .overlay {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                }
                .scaledToFill()
                
            
            VStack{
                VStack {
                    Text("You are a \(viewModel.role?.rawValue ?? "Unknown")!")
                        .font(.custom("VinerHandITC", size: 45))
                        .foregroundStyle(Color.title)
                    
                    if let role = viewModel.role {
                        switch role {
                        case .cultist:
                            Text("Protect and defend the cult")
                                .font(.custom("Almendra-Regular.ttf", size: 24))
                                .foregroundStyle(Color.title)
                        case .heretic:
                            Text("Destroy and sabotage the cult")
                        }
                    }
                }
                .padding(.top, 100)
                
                VStack{
                    Image("\(viewModel.role?.rawValue ?? "cultist")_\(viewModel.character.rawValue)_001")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 350)
                        .shadow(color: .yellow.opacity(0.4), radius: 5, x: 0, y: 0)
                        .padding(.bottom, 30)
                    
                    Button {
                        print("go to content view")
                    } label: {
                        ZStack {
                            Image("\(viewModel.role?.rawValue ?? "heretic")_button_001")
                            Text("Iniciar")
                                .font(.system(size: 26))
                                .foregroundColor(Color.title)
                        }
                    }
                }
                .padding(.top, 100)
            }
        }
    }
}

#Preview {
    RoleView()
}
