//
//  PlayView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 20/05/25.
//
import SpriteKit
import SwiftUI

struct PlayView: View {
    @EnvironmentObject var vm: GameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {

//                // Camada de gradiente radial para escurecer a tela
//                RadialGradient(
//                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black]),
//                    center: .center,
//                    startRadius: 10,
//                    endRadius: 300
//                )
//                .ignoresSafeArea()
                
                VStack{
                    Image("TitleGamePhone")
                        .resizable()
                        .frame(width: 309, height: 154)
                    Spacer()
                    
                    ZStack{
                        Image("cultist_button_001")
                            .resizable()
                            .frame(width: 200, height: 51)
                        NavigationLink {
                            GameView()
                                .environmentObject(vm)
                                .navigationBarBackButtonHidden(true)
                            
                        } label: {
                            Text("Pair")
                                .font(.custom("Almendra-Regular", size: 26))
                                .foregroundStyle(Color.title)
                            
                        }
                    }
                }
                .padding(.bottom)
                .padding(.top, 104)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
