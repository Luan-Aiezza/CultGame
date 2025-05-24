import SwiftUI
import SpriteKit
import AVFoundation

struct TvTransitionTextsView: View {
    
    enum SequenceType {
        case introSequence, endSequence
    }

    let type: SequenceType
    let isFirstRound: Bool
    let onComplete: () -> Void
    
    @State private var currentStep = 0
    @State private var selectedText: String = ""
    
    private var customTextColor: Color {
        Color(red: 227 / 255, green: 206 / 255, blue: 167 / 255)
    }

    // Frases
    private let fixedIntroText = "The village awakens under the gaze of dawn — eyes open to what is yet to come..."
    
    private let introAlternatives = [
        "The first light of morning touches the village - and with it, the weight of past choices.",
        "The sun rises over the village - the cycle begins again, and sacrifice may lie ahead.",
        "The light of the new day dawns on the village - but not everyone should have woken up.",
        "Morning blooms over the village - but beneath its beauty, the silence of what is to come grows.",
        "The day rises again - but the village is no longer the same, and the cult never forgets.",
        "Dawn is breaking over the village - but something ancient is also awakening over the land.",
        "The sun breaks through the horizon - and with it, the eyes of the occult once again turn to the village.",
        "The mist subsides in the morning - but there are eyes in the forest that have never stopped watching.",
        "Dawn is breaking over the village - and the air carries the omen of a new call.",
        "The village awakens under the gaze of the cult - and there is a traitor among those who pray.",
        "The new sun rises - and the eyes of the cult seek the face of the traitor."
    ]
    
    private let endSequenceAlternatives = [
        "The last light of the day fades — and with it, the silence that precedes the verdict.",
        "The evening has arrived like a warning. It’s time to choose paths, and some have no return.",
        "The sky is covered in gray — it is the time for heavy words and sealed fates.",
        "The last breath of the day carries a strange weight. Now, it’s time to decide what will endure.",
        "The shadow advances over the village — and with it, the moment to point, to judge… and to lose.",
        "The sun slowly drowns on the horizon — and with it, poorly buried secrets begin to breathe.",
        "The dusk stitches the village with threads of mistrust. Each shadow, a blind spot.",
        "Night announces itself like an ancient whisper, sliding through half-open doors and averted gazes.",
        "The day says goodbye in silence — the kind that weighs before the sentence.",
        "With nightfall, no promises remain — only consequences.",
        "The sky darkens, but eyes turn against one another.",
        "The night has closed like an ancient book — but no day ends without leaving marks on the pages of tomorrow.",
        "The cult’s time has run out — and now, under the moon’s gaze, the village wonders what comes next.",
        "Everything seemed too calm. As if someone had silenced the chaos before it could begin.",
        "The shadow has fallen like a sacred veil. What has been done can no longer be undone.",
        "The night rose heavy — as if bearing the weight of a newborn secret."
    ]
    
    var body: some View {
        ZStack {
            // VIEW DO MAPA
            SpriteView(scene: scene)
                .ignoresSafeArea(.all)
            
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
            
            // Step-specific content
            contentForStep(currentStep)
        }
        .onAppear {
            if type == .introSequence {
                selectedText = isFirstRound ? fixedIntroText : (introAlternatives.randomElement() ?? fixedIntroText)
            } else {
                selectedText = endSequenceAlternatives.randomElement() ?? ""
            }
            advanceStep(after: 5)
        }
    }

    @ViewBuilder
    private func contentForStep(_ step: Int) -> some View {
        switch type {
        case .introSequence:
            switch step {
            case 0:
                centeredText(selectedText)
            case 1:
                centeredImageWithText(image: "PhoneIcon", text: "Your role awaits you")
            case 2:
                centeredTextWithImage(text: "Distributing cards", image: "DeckIcon")
            default:
                EmptyView()
            }
            
        case .endSequence:
            switch step {
            case 0:
                VStack(spacing: 12) {
                    centeredText("In the darkness of the last night, the other cult members acted — but what did they do?")
                    Text("Time to discuss the cult's hidden choices")
                        .font(.custom("Almendra-Regular", size: 35))
                        .foregroundColor(Color(red: 211 / 255, green: 180 / 255, blue: 125 / 255))
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .transition(.opacity)
            case 1:
                centeredText(selectedText)
            case 2:
                centeredTextWithImage(text: "Vote for the Heretic", image: "PhoneIcon")
            default:
                EmptyView()
            }
        }
    }
    
    private func centeredText(_ text: String) -> some View {
        Text(text)
            .font(.custom("Almendra-Regular", size: 65))
            .foregroundColor(customTextColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 362)
            .transition(.opacity)
    }
    
    private func centeredImageWithText(image: String, text: String) -> some View {
        VStack(spacing: 20) {
            Image(image)
                .resizable()
                .frame(width: 160, height: 271)
            Text(text)
                .font(.custom("Almendra-Regular", size: 65))
                .foregroundColor(customTextColor)
                .multilineTextAlignment(.center)
        }
        .transition(.opacity)
    }
    
    private func centeredTextWithImage(text: String, image: String) -> some View {
        VStack(spacing: 20) {
            Text(text)
                .font(.custom("Almendra-Regular", size: 65))
                .foregroundColor(customTextColor)
                .multilineTextAlignment(.center)
            Image(image)
                .resizable()
                .frame(width: 160, height: 271)
        }
        .transition(.opacity)
    }
    
    private func advanceStep(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                currentStep += 1
            }
            if (type == .introSequence && currentStep < 3) || (type == .endSequence && currentStep < 2) {
                advanceStep(after: 5)
            } else {
                onComplete()
            }
        }
    }
}
