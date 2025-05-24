import SwiftUI
import SpriteKit
import AVFoundation

struct ResultView: View {
    @EnvironmentObject var multiplayerManager : MultiplayerManager
    
    var body: some View {
        ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.black.opacity(0.6))
                        .frame(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/3)
                    VStack() {
                        
                    Text("Resultados da Rodada")
                            .font(.custom("VinerHandITC", size: 46))
                            .foregroundColor(Color.title)
                            .padding(.vertical, 20)
                        StatusBarView()
                        
                        if let killedName = multiplayerManager.killed?.character?.displayName {
                            Text("\(killedName) foi eliminado!")
                                    .font(.custom("VinerHandITC", size: 46))
                                    .foregroundColor(Color.title)
                                    .padding(.vertical, 20)
                            
                            ZStack {
                                Image("\(killedName.capitalized)")
                                Image(systemName: "xmark.app")
                                    .font(.system(size: 64))
                                    .foregroundColor(.red)
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
