//
//  MurderView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 21/05/25.
//

import SwiftUI
import MultipeerConnectivity

struct MurderView: View {
    @EnvironmentObject var pvm: PlayCardViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPeer: MCPeerID? = nil
    @State private var voteConfirmed = false

    var body: some View {
        Color.black.opacity(0.6)
            .ignoresSafeArea()
            .transition(.opacity)
            .overlay(
                VStack {
                    Text("Escolha alguém para matar")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                    
                    // Você pode adicionar aqui os botões de seleção mais tarde
                    ForEach(multiplayerManager.connectedPeers.filter {
                        let isNotMyPeer = $0 != multiplayerManager.myPeerID
                        let isNotTV = !$0.displayName.contains("TV")
                        let isActive = multiplayerManager.players[$0]?.state == .active
                        return isNotMyPeer && isNotTV && isActive
                    }, id: \.self) { peer in
                        if let player = multiplayerManager.players[peer] {
                            Button(action: {
                                selectedPeer = peer
                                voteConfirmed = false
                            }) {
                                HStack {
                                    Text(peer.displayName)
                                        .fontWeight(peer == selectedPeer ? .bold : .regular)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Text(player.role?.rawValue.capitalized ?? "Sem papel")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(peer == selectedPeer ? Color.red : Color.gray.opacity(0.2), lineWidth: peer == selectedPeer ? 2 : 1)
                                        .background(
                                            peer == selectedPeer ? Color.red.opacity(0.1) : Color.clear
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Button("Cancelar") {
                        pvm.toggleMurderView()
                    }
                    .padding(.top, 20)
                    .foregroundColor(.white.opacity(0.8))
                }
            )
    }
}

#Preview {
    MurderView()
}
