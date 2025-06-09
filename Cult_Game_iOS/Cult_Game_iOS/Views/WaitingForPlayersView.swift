import SwiftUI

extension Character {
    var displayName: String {
        switch self {
        case .fox: return "Fox"
        case .panda: return "Panda"
        case .bunny: return "Bunny"
        case .tiger: return "Tiger"
        case .deer: return "Deer"
        case .pig: return "Pig"
        case .wolf: return "Wolf"
        }
    }
}

struct WaitingForPlayersView: View {
    @EnvironmentObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Image("background_002")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.5))

            VStack {
                Spacer()

                if let character = viewModel.player.character {
                    Text(character.displayName)
                        .font(.custom("Almendra-Regular", size: 38))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .padding(.bottom, 16)

                    ZStack {
                        Image("PlayerCardBackground")
                            .resizable()
                            .frame(width: 200, height: 200)

                        Image(character.displayName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 185)
                            .offset(y: 5)
                    }

                    Spacer()

                    Text("Waiting for Players...")
                        .font(.custom("Almendra-Regular", size: 18))
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .padding(.bottom, 24)
                } else {
                    Text("No player...")
                        .font(.custom("Almendra-Regular", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .zIndex(6)
                }
            }
        }
    }
}
