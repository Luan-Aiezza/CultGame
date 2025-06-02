import SwiftUI
import SpriteKit
import AVFoundation

struct ResultView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.black.opacity(0.6))
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack() {
                    
                    Text("Round results")
                        .font(.custom("VinerHandITC", size: 46))
                        .foregroundColor(Color.title)
                        .padding(.vertical, 20)
                    StatusBarView()
                    
                    if let killedName = multiplayerManager.killed?.character?.displayName {
                        Text("\(killedName) was eliminated!")
                            .font(.custom("VinerHandITC", size: 46))
                            .foregroundColor(Color.title)
                            .padding(.vertical, 20)
                        
                        ZStack {
                            Image("\(killedName.capitalized)")
                        }
                    }
                    
                }
                
            }
            
        }
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                multiplayerManager.applyPendingEffects()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
                multiplayerManager.sendGamePhase(.elimination)
            }
            
        }
        .padding()
        
    }
}

#Preview {
    ResultView()
        .environmentObject(MultiplayerManager.shared)
}
