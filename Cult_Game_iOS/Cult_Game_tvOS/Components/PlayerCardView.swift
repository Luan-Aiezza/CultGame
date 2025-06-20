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
                        .font(.custom("Almendra-Regular", size: 45))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: width - (height - 30) - 50, alignment: .leading) // <- Garantir espaço estável
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
                        .font(.custom("Almendra-Regular", size: 45))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: width - (height - 30) - 50, alignment: .leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(width: width, height: height)
    }
}
