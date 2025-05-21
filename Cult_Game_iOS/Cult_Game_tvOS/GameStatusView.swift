import SwiftUI
import SpriteKit

struct GameStatusView: View {
    
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        ZStack {
            
            // VIEW DO MAPA
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
            
//            //A PARTIR DAQUI SERÁ UI
//                VStack(spacing: 10) {
//                    Text("Faith points: \(multiplayerManager.globalState.sharedFaithPoints)")
//                        .foregroundColor(.green)
//                        .font(.title2)
//
//                    ForEach(multiplayerManager.globalState.heresyPoints.sorted(by: { $0.key < $1.key }), id: \.key) { peerName, heresy in
//                        HStack {
//                            Text("Heretic: \(peerName.prefix(10))")
//                            Spacer()
//                            Text("Heresy: \(heresy)")
//                        }
//                        .foregroundColor(.red)
//                        .font(.title3)
//                    }
//
//                    Text("Followers: \(multiplayerManager.globalState.followers)")
//                        .foregroundColor(.blue)
//                        .font(.title2)
//                }
//                .padding()
            }
            .padding()
        }
    }

