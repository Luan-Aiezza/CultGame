//
//  RoleView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 12/05/25.


import SwiftUI

struct RoleView: View {
    
    @ObservedObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        NavigationStack {
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
                    
                    HStack(){
                        Spacer()
                        Button {
                            MultiplayerManager.shared.eliminate(peer: viewModel.getID())
                        } label: {
                            Image("\(viewModel.role?.rawValue ?? "cultist")buttonX")
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 35)

                    }
                    
                    VStack {
                        Text("You are a \(viewModel.role?.rawValue ?? "Unknown")!")
                            .font(.custom("VinerHandITC", size: 40))
                            .foregroundStyle(Color.title)
                        
                        if let role = viewModel.role {
                            switch role {
                            case .cultist:
                                Text("Protect and defend the cult")
                                    .font(.custom("Almendra-Regular", size: 20))
                                    .foregroundStyle(Color.title)
                            case .heretic:
                                Text("Destroy and sabotage the cult")
                                    .font(.custom("Almendra-Regular", size: 20))
                                    .foregroundStyle(Color.titleHeretic)
                            }
                        }
                    }
                    .padding(.top, 90)
                    
                    VStack{
                            if let role = viewModel.role {
                                switch role {
                                case .cultist:
                                    Image("\(viewModel.role?.rawValue ?? "cultist")_\(viewModel.character.rawValue)_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .yellow.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                    
                                case .heretic:
                                    Image("\(viewModel.role?.rawValue ?? "heretic")_\(viewModel.character.rawValue)_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                
                            }
                        }
                        
                        NavigationLink {
                            ContentView()
                        } label: {
                            ZStack {
                                Image("\(viewModel.role?.rawValue ?? "heretic")_button_001")
                                Text("Iniciar")
                                    .foregroundColor(Color.title)
                                    .font(.custom("Almendra-Regular", size: 26))
                            }
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 25)
                }
            }
        }
    } 

}

#Preview {
    RoleView()
}
