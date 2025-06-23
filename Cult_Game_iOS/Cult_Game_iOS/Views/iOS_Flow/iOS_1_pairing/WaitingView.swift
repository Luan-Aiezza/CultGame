//
//  WaitingView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//
import SwiftUI
import SpriteKit

struct WaitingView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject private var multiplayerManager = MultiplayerManager.shared
    
    var myCharacter: Character? {
        let myDisplayName = vm.multiplayerManager.myPeerID.displayName
        let character = vm.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
        return character
    }
    
    var body: some View {
        ZStack {
            
            Image("background_002")
                .resizable()
                .overlay {
                    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                .scaledToFill()//RETIRAR DEPOIS

            // Camada de gradiente radial para escurecer a tela
            RadialGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black]),
                center: .center,
                startRadius: 10,
                endRadius: 300
            )
            .ignoresSafeArea()
            
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
                        
                        Image("\(character.displayName.capitalized)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                    }
                    .padding(.horizontal)
                }
            } else{
                VStack{
                    Spacer()
                    Text("Waiting for players...")
                        .font(Font.custom("Almendra-Regular", size: 23))
                        .foregroundColor(Color(red:211/255, green:180/255, blue:125/255))
                }.padding(.bottom)
            }
        }
    }
}
