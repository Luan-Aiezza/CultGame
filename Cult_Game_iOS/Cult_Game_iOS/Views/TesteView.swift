import SwiftUI
import MultipeerConnectivity

struct TesteView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var selectedPlayerID: String? = nil
    @State private var voteConfirmed = false
    @State private var glowRotation: Double = 0
    var myCharacter: Character? {
        let myDisplayName = viewModel.multiplayerManager.myPeerID.displayName
        let character = viewModel.multiplayerManager.players.first {
            $0.key == myDisplayName
        }?.value.character
        
        return character
    }

    private let horizontalPadding: CGFloat = 26
    private let horizontalSpacing: CGFloat = 18
    private let verticalSpacing: CGFloat = 34
    private let cardHeight: CGFloat = 68

    private var columns: [GridItem] {
        [GridItem(.flexible(), spacing: horizontalSpacing),
         GridItem(.flexible(), spacing: horizontalSpacing)]
    }

    var body: some View {
        
        VStack {
            
            Button {
                multiplayerManager.testSendPhaseToHost(frase: viewModel.peerID.displayName)
            } label: {
                Text("teste")
            }

            }.onAppear {
                multiplayerManager.joinSession()

                NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                    if let role = notification.object as? PlayerRole {
                        viewModel.selectRole(role)
                    }
                }
                
                NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
                    if let role = notification.object as? Character {
                        viewModel.assignCharacter(role)
                    }
                }
                
                NotificationCenter.default.addObserver(forName: .didReceiveCharacter, object: nil, queue: .main) { notification in
                    if let character = notification.object as? Character {
                        // Atualize a UI com o personagem recebido
                        print("🎨 Recebi meu personagem: \(character)")
                    }
                }

            }
        }
    }


#Preview {
    MurderView()
}
