import SwiftUI

struct PlayerCardView: View {
    let player: PlayerModel
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("accent_button").opacity(0.2),
                            Color("accent_button").opacity(0.4),
                            Color("accent_button").opacity(0.2)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: width, height: height)
                .blur(radius: 0.1)
            
            if let displayName = player.character?.displayName, !displayName.isEmpty {
                Image("imageAnimals")
                    .resizable()
                    .frame(width: width, height: height)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image(displayName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: height - 30, height: height - 30)
                    Text(displayName)
                        .foregroundColor(.title)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.custom("Almendra-Regular", size: 45))
                    Spacer()
                }
                .padding(.horizontal, 16)
            } else {
                Image("personPlaceholder")
                    .resizable()
                    .frame(width: width, height: height)
                    .cornerRadius(10)
                HStack(spacing: 10) {
                    Image("personPlaceholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: height - 30, height: height - 30)
                    Text("Wait...")
                        .foregroundColor(.gray)
                        .fontWeight(.regular)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.custom("Almendra-Regular", size: 45))
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(width: width, height: height)
        
    }
}
