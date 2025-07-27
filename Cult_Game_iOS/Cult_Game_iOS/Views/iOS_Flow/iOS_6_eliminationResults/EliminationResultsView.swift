import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

struct EliminationResultsView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @EnvironmentObject var viewModel: GameViewModel
    @State var isDisconnected = false
    
    var isPlayerEliminated: Bool {
        let eliminated = viewModel.eliminatedPlayer
        // Checa id do modelo, peerID local e displayName para cobrir todos os casos possíveis de identificação do jogador local
        return eliminated == viewModel.player.id ||
        eliminated == multiplayerManager.myPeerID.displayName ||
        eliminated == viewModel.peerID
    }
    
    var eliminatedIsHeretic: Bool {
        guard let eliminated = viewModel.eliminatedPlayer,
              let player = multiplayerManager.players[eliminated],
              let role = player.role else { return false }
        return role == .heretic
    }
    
    var eliminatedCharacter: Character? {
        guard let eliminated = viewModel.eliminatedPlayer,
              let player = multiplayerManager.players[eliminated] else {
            return nil
        }
        return player.character
    }
    
    let cultistGold = Color(red: 1.0, green: 0.91, blue: 0.75)
    
    var body: some View {
        ZStack {
            
            Image("background_002")
                .resizable()
                .overlay {
                    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                .scaledToFill()//RETIRAR DEPOIS
            
            
            if isPlayerEliminated {
                FollowTvViewDead()
                    .ignoresSafeArea(.all)
            } else {
                FollowTvViewVoting()
                    .ignoresSafeArea(.all)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        multiplayerManager.disconnect()
                        isDisconnected = true
                    }) {
                        Image("exit")
                            .resizable()
                            .frame(width: 48, height: 35)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 17.4)
                }
                .padding(.top, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .onAppear {
            // This check now works reliably every round due to the eliminatedPlayer reset logic in GameViewModel+Elimination.swift
            if isPlayerEliminated && !isDisconnected {
                multiplayerManager.disconnect()
            }
        }
    }
}
