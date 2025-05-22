import SwiftUI
import SpriteKit
import Combine

struct StatusBarView: View {
    
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var tvResponse = 1.5

    
    var body: some View {
        statusBar(iconBar: "FaithIcon", title: "Faith", value: multiplayerManager.globalState.sharedFaithPoints, max: 85, color: Color(red: 1, green: 0.84, blue: 0.4), background: Color(red: 1, green: 0.94, blue: 0.76), flash: Color(red: 1, green: 0.7, blue: 0.2))
        statusBar(iconBar: "FaithfulIcon", title: "Faithful", value: multiplayerManager.globalState.followers, max: 100, color: .white, background: Color(white: 0.85), flash: Color(white: 0.7))
        statusBar(iconBar: "HeresyIcon", title: "Heresy", value: multiplayerManager.globalState.followers, max: 100, color: Color(red: 0.85, green: 0.2, blue: 0.2), background: Color(red: 1.0, green: 0.7, blue: 0.7), flash: Color(red: 0.5, green: 0, blue: 0))//MUDAR
        
//                        if let myName = multiplayerManager.displayName,
//                           let myHeresy = multiplayerManager.globalState.heresyPoints[myName] {
//                            statusBar(title: "Heretic", value: myHeresy, max: 15, color: Color(red: 0.85, green: 0.2, blue: 0.2), background: Color(red: 1.0, green: 0.7, blue: 0.7), flash: Color(red: 0.5, green: 0, blue: 0))
//                        }
    }
    
    func statusBar(iconBar: String, title: String, value: Int, max: Int, color: Color, background: Color, flash: Color) -> some View {
        ZStack(alignment: .center) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(background)
                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(flash)
                        .frame(width: CGFloat(value) / CGFloat(max) * geo.size.width)
                        .opacity(0.2)
                    RoundedRectangle(cornerRadius: geo.size.height / 2)
                        .fill(color)
                        .frame(width: CGFloat(value) / CGFloat(max) * geo.size.width)

                    HStack {
                        Image(iconBar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20*tvResponse, height: 20*tvResponse)
                        
                    }
                    .padding(.leading, 7)
                    .foregroundColor(.black)
                    
                    HStack {
                        Text(title)
                            .font(.custom("Almendra-Regular", size: 24*tvResponse))
                            .frame(alignment: .leading)
                            .opacity(0.5)
                    }
                    .padding(.leading, 42)
                    .foregroundColor(.black)
                }
            }
            .frame(width: 359 * tvResponse, height: 29 * tvResponse)
            
            Text("\(value)/\(max)")
                .font(.custom("Almendra-Regular", size: 24*tvResponse))
                .frame(alignment: .center)
                .foregroundColor(.black)
            
            Image("BarBorder")
                .resizable()
                .frame(width: 365 * tvResponse, height: 35 * tvResponse)
        }
        .frame(width: 365 * tvResponse, height: 35 * tvResponse) // Garantir alinhamento total

    }

}
