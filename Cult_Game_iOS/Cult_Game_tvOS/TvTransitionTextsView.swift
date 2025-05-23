import SwiftUI
import SpriteKit
import AVFoundation

struct TvTransitionTextsView: View {
    
    enum SequenceType {
        case introSequence, endSequence
    }
    
    let type: SequenceType
    let onComplete: () -> Void
    
    @State private var currentStep = 0
    
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
            advanceStep(after: 5)
        }
    }
    
    private var customTextColor: Color {
        Color(red: 227 / 255, green: 206 / 255, blue: 167 / 255)
    }
    
    @ViewBuilder
    private func contentForStep(_ step: Int) -> some View {
        switch type {
        case .introSequence:
            switch step {
            case 0:
                centeredText("The village awakens under the gaze of dawn — eyes open to what is yet to come...")
            case 1:
                centeredImageWithText(image: "PhoneIcon", text: "Your role awaits you")
            case 2:
                centeredTextWithImage(text: "Distributing cards", image: "DeckIcon")
            default:
                Text("Completed")
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
                centeredText("The last light of day fades — and with it, the silence before the verdict.")
            case 2:
                centeredTextWithImage(text: "Vote for the Heretic", image: "PhoneIcon")
            default:
                Text("Completed")
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
            if currentStep < 3 {
                advanceStep(after: 5)
            } else {
                onComplete()
            }
        }
    }
}
