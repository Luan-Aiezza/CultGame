import SwiftUI
import SpriteKit
import AVFoundation

struct VictoryTvView: View {
    let outcome: GameOutcome
    @EnvironmentObject var viewModel: GameViewModel
    let multiplayer = GameKitMultiplayerManager.shared
    
    private let hereticRed = Color(red: 1.0, green: 0.32, blue: 0.32) // FF5151

    private var content: VictoryScreenContent {
        VictoryScreenContent.for(outcome: outcome)
    }

    private var hereticImageName: String? {
        guard outcome.isHereticVictory,
              let character = viewModel.multiplayer.players.first(where: { $0.value.role == .heretic })?.value.character
        else { return nil }

        return "\(character.displayName.capitalized)H"
    }

    private var hereticDefeatImageName: String? {
        guard outcome.isCultistVictory,
              let character = viewModel.multiplayer.players.first(where: { $0.value.role == .heretic })?.value.character
        else { return nil }

        return "Heretic\(character.displayName.capitalized)Died"
    }

    private var hereticName: String? {
        guard outcome.isHereticVictory,
              let character = viewModel.multiplayer.players.first(where: { $0.value.role == .heretic })?.value.character
        else { return nil }

        return character.rawValue.capitalized
    }

    var body: some View {
        ZStack {
            Image(content.backgroundImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.resetGame()
                        viewModel.multiplayer.currentPhase = .pairing
                    }) {
                        Image("Exit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 40)
                    }
                    .tint(Color.accentButton)
                    .padding(.trailing, 95)
                    .padding(.bottom, 24)
                }

                Text(content.title)
                    .font(.custom("VinerHandITC", size: 70))
                    .bold()
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .multilineTextAlignment(.center)
                    .frame(width: 1086, height: 82.5)
                    .padding(.horizontal, 24)

                Text(content.description)
                    .font(.custom("Almendra-Regular", size: 36))
                    .foregroundColor(outcome.isHereticVictory ? hereticRed : Color(red: 1.0, green: 0.91, blue: 0.75))
                    .multilineTextAlignment(.center)
                    .frame(width: 793.5, height: 144)
                    .padding(.horizontal, 32)

                Spacer()

                if outcome.isHereticVictory {
                    ZStack {
                        Image("CircleHeretic")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 293)

                        if let imageName = hereticImageName {
                            GlowingCircleView(characterImageName: imageName)
                        }
                    }

                    if let name = hereticName {
                        Text("Heretic – \(name)")
                            .font(.custom("VinerHandITC", size: 30))
                            .bold()
                            .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                            .multilineTextAlignment(.center)
                            .frame(width: 450, height: 150)
                            .padding(.horizontal, 24)
                    }
                } else if let defeatImage = hereticDefeatImageName {
                    HereticDefeatImageView(imageName: defeatImage)
                }

                Spacer()
            }
            .padding()
        }
        .onAppear {
            MainScene.shared?.zoomIn()
            AudioManager.shared.playBackgroundMusic(named: "Background_Map")
        }
    }
}
