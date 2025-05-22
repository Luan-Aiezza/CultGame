//
//  WaitingView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct WaitingView: View {
    @EnvironmentObject var vm : GameViewModel
    
    var body: some View {
        if let character = vm.player.character {
            Text(character.displayName)
        } else {
            Text("esperando personagem")
            
            Button {
                print(vm.currentPhase)
            } label: {
                Text("Teste de fase")
                    .padding(200)
            }
        }
    }
}

#Preview {
    WaitingView()
        .environmentObject(GameViewModel())
}
