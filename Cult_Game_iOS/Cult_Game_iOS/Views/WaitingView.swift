import SwiftUI
import SpriteKit
import GameKit

struct WaitingView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayer = GameKitMultiplayerManager.shared

    @State private var hasAttemptedJoin = false
    @State private var joinError: String?

    var myCharacter: Character? {
        let myDisplayName = multiplayer.localPlayer.displayName
        return multiplayer.players[myDisplayName]?.character
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
                    Text("Waiting for Apple TV to start match...")
                        .font(Font.custom("Almendra-Regular", size: 23))
                        .foregroundColor(Color(red:211/255, green:180/255, blue:125/255))

                    if let joinError {
                        Text("Erro: \(joinError)")
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            if !hasAttemptedJoin {
                hasAttemptedJoin = true
                // Nenhuma ação de matchmaking aqui — apenas escutando convite
            }
        }
    }
}
