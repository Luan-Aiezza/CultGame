//
//  WaitingView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//
import SwiftUI

struct WaitingView: View {
    @EnvironmentObject var vm: GameViewModel
    @State private var character: Character = .wolf

    var body: some View {
        ZStack {
            Image("BackgroundWaitingForPlayers")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.5))
            
            VStack {
                
                Text(character.displayName.uppercased())
                    .font(Font.custom("Almendra-Regular", size: 38))
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .padding(.bottom, 16)
                
                ZStack {
                    Image("PlayerCardBackground")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    Image("\(character.displayName.lowercased())")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                    
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    WaitingView()
        .environmentObject(GameViewModel())
}
