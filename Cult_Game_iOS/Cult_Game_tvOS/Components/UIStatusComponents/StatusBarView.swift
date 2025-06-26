import SwiftUI
import SpriteKit
import Combine

struct StatusBarAnimatedView: View {
    var iconBar: String
    var title: String
    var value: Int
    var max: Int
    var color: Color
    var background: Color
    var flash: Color

    @State private var animatedValue: CGFloat = 0

    let tvResponse = 1.5

    var body: some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(background)

                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(flash)
                        .frame(width: animatedValue * geo.size.width)
                        .opacity(0.2)

                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(color)
                        .frame(width: animatedValue * geo.size.width)

                    HStack {
                        Image(iconBar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20*tvResponse, height: 20*tvResponse)
                    }
                    .padding(.leading, 7)

                    HStack {
                        Text(title)
                            .font(.custom("Almendra-Regular", size: 24*tvResponse))
                            .frame(alignment: .leading)
                            .colorInvert()
                            .opacity(0.5)
                    }
                    .padding(.leading, 42)
                }
            }
            .frame(width: 355 * tvResponse, height: 29 * tvResponse)

            Text("\(value)/\(max)")
                .font(.custom("Almendra-Regular", size: 24*tvResponse))
                .colorInvert()
                .frame(alignment: .center)

            Image("BarBorder")
                .resizable()
                .frame(width: 365 * tvResponse, height: 35 * tvResponse)
        }
        .frame(width: 365 * tvResponse, height: 35 * tvResponse)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = CGFloat(value) / CGFloat(max)
            }
        }
        .onChange(of: value) { _, newValue in
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedValue = CGFloat(newValue) / CGFloat(max)
            }
        }
    }
}


struct StatusBarView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    var tvResponse = 1.5
    
    var body: some View {
        // Faith Bar
        StatusBarAnimatedView(
            iconBar: "FaithIcon",
            title: "Faith",
            value: multiplayerManager.globalState.sharedFaithPoints,
            max: max(1, 85),
            color: Color(red: 1, green: 0.84, blue: 0.4),
            background: Color(red: 1, green: 0.94, blue: 0.76),
            flash: Color(red: 1, green: 0.7, blue: 0.2)
        )
        
        // Followers Bar
        StatusBarAnimatedView(
            iconBar: "FaithfulIcon",
            title: "Faithful",
            value: multiplayerManager.globalState.followers,
            max: max(1, 100),
            color: .white,
            background: Color(white: 0.85),
            flash: Color(white: 0.7)
        )
        
        // Heresy Bar
        StatusBarAnimatedView(
            iconBar: "HeresyIcon",
            title: "Heresy",
            value: multiplayerManager.globalState.heresyPoints,
            max: max(1, 100),
            color: Color(red: 0.85, green: 0.2, blue: 0.2),
            background: Color(red: 1.0, green: 0.7, blue: 0.7),
            flash: Color(red: 0.5, green: 0, blue: 0)
        )
    }
}
