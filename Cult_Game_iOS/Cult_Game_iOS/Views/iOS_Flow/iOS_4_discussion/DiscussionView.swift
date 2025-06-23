//
//  DiscussionView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import SwiftUI

struct DiscussionView: View {
    
    @EnvironmentObject var vm : GameViewModel
    var body: some View {
        Text("DiscussionView")
            .onAppear() {
                print("estado atual do player:  \(vm.player.character?.displayName) = \(vm.player.state)")
            }
    }
}

#Preview {
    DiscussionView()
}
