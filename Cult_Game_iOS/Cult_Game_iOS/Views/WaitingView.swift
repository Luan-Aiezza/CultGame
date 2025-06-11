import SwiftUI
import SpriteKit
import GameKit
import Combine

struct WaitingView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayer = GameKitMultiplayerManager.shared
    
    @State private var hasAttemptedJoin = false
    @State private var joinError: String?
    @State private var connectionStatus: String = "Aguardando Apple TV iniciar..."
    
    var myCharacter: Character? {
        let myID = multiplayer.localPlayer.playerID
        return multiplayer.players[myID]?.character
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black]),
                center: .center,
                startRadius: 10,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            VStack {
                if let character = myCharacter {
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
                } else {
                    Spacer()
                    
                    Text(joinError != nil ? "Erro: \(joinError!)" : connectionStatus)
                        .font(Font.custom("Almendra-Regular", size: 23))
                        .foregroundColor(joinError != nil ? .red : Color(red:211/255, green:180/255, blue:125/255))
                    
                    if !hasAttemptedJoin || joinError != nil {
                        Button("Entrar via Game Center") {
                            tryJoinMatch()
                        }
                        .padding(.top, 12)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            if !hasAttemptedJoin {
                tryJoinMatch()
            }
        }
    }
    
    func tryJoinMatch() {
        hasAttemptedJoin = true
        joinError = nil
        connectionStatus = "Buscando partida com Apple TV..."
        multiplayer.startMatchmaking(asHost: false) { error in
            if let error = error {
                joinError = error.localizedDescription
                connectionStatus = "Erro ao entrar na partida"
            } else {
                connectionStatus = "Conectado!"
            }
        }
    }
}
