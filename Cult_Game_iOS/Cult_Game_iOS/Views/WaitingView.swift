//
//  WaitingView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//
import SwiftUI

struct WaitingView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject private var multiplayerManager = MultiplayerManager.shared
    
    var myCharacter: Character? {
        let myDisplayName = vm.multiplayerManager.myPeerID.displayName
        let character = vm.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
        print("Meu personagem atual: \(String(describing: character))")
        print("Meu peer \(vm.multiplayerManager.myPeerID)")
        print("Meu display Name \(vm.multiplayerManager.myPeerID)")
        
        print(vm.multiplayerManager.players)
        print(vm.multiplayerManager.players[vm.multiplayerManager.myPeerID.displayName] ?? "dad" )
        return character
    }
    
    var body: some View {
        ZStack {
            Image("BackgroundWaitingForPlayers")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.5))
            
            if let character = myCharacter {
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
}
