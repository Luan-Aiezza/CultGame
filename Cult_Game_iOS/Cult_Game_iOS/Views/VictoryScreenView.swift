import SwiftUI
import SpriteKit
import AVFoundation

struct VictoryScreenView: View {
    let role: PlayerRole
    let outcome: GameOutcome

    @State private var navigateToWaiting = false
    @State private var isDisconnected = false

    @ObservedObject var multiplayerManager = GameKitMultiplayerManager.shared
    @EnvironmentObject var viewModel: GameViewModel

    let hereticRed = Color(red: 1.0, green: 0.32, blue: 0.32) // FF5151

    var content: VictoryScreenContent {
        VictoryScreenContent.for(role: role, outcome: outcome)
    }

    var hereticImageName: String? {
        guard outcome.isHereticVictory else { return nil }

        if let (_, model) = multiplayerManager.players.first(where: { $0.value.role == .heretic }) {
            let character = model.character
            return "\(character?.rawValue.capitalized ?? "")H"
        }

        return nil
    }

    var hereticDefeatImageName: String? {
        guard outcome.isCultistVictory else { return nil }

        if let model = multiplayerManager.players.first(where: { $0.value.role == .heretic })?.value {
            return "Heretic\(model.character?.rawValue.capitalized ?? "")DiedIPHONE"
        }

        return nil
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        multiplayerManager.disconnectAll()
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

            VStack(spacing: 40) {
                Text(content.title)
                    .font(.custom("VinerHandITC", size: 45))
                    .bold()
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .multilineTextAlignment(.center)
                    .frame(width: 260)
                    .padding(.horizontal, 24)
                    .padding(.top, 80)

                Text(content.description)
                    .font(.custom("Almendra-Regular", size: 24))
                    .foregroundColor({
                        switch outcome {
                        case .hereticVictoryFollowers, .hereticVictoryBalance:
                            return hereticRed
                        default:
                            return Color(red: 211/255, green: 180/255, blue: 125/255)
                        }
                    }())
                    .multilineTextAlignment(.center)
                    .lineSpacing(0.2)
                    .frame(width: 312)
                    .padding(.horizontal, 32)

                if [.hereticVictoryFollowers, .hereticVictoryBalance].contains(outcome) {
                    ZStack {
                        Image("CircleHeretic")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 293)

                        if let imageName = hereticImageName {
                            GlowingCircleView(characterImageName: imageName)
                        }
                    }
                } else {
                    if let defeatImage = hereticDefeatImageName {
                        //HereticDefeatImageViewiphone(imageName: defeatImage)
                        ///ajuste
                    }
                }

                Spacer()
            }
            .navigationDestination(isPresented: $isDisconnected) {
                PlayView()
            }
            .padding()
        }
        .onAppear { }
    }
}
