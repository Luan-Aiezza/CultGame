import SwiftUI
import SpriteKit
import AVFoundation

struct ResultView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        ZStack {
            
            // Radial gradient overlay
            Rectangle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0.7), location: 0.107),
                            .init(color: Color.black.opacity(0.56), location: 0.6394),
                            .init(color: Color.black.opacity(0.413), location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 600
                    )
                )
                .ignoresSafeArea()
            
            VStack() {
                
                Text("Round results")
                    .font(.custom("VinerHandITC", size: 46))
                    .foregroundColor(Color.title)
                    .padding(.vertical, 20)
                StatusBarView()
                
                //ele não esta caindo na condição
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
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                multiplayerManager.applyPendingEffects()
            }
            
        }
        .padding()
        
    }
}

#Preview {
    ResultView()
        .environmentObject(MultiplayerManager.shared)
}
