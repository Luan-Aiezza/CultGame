//
//  PlayerCellView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 22/05/25.
//

import SwiftUI

struct PlayerCellView: View {
    let player: PlayerModel
    let isSelected: Bool
    @Binding var glowRotation: Double
    let onSelect: () -> Void
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            AngularGradient(
                                gradient: Gradient(colors: [
                                    Color.red.opacity(0.1),
                                    Color.red.opacity(0.9),
                                    Color.red.opacity(0.1)
                                ]),
                                center: .center,
                                angle: .degrees(glowRotation)
                            )
                        )
                        .frame(width: width, height: height)
                        .blur(radius: 0.5)
                        .opacity(0.6)
                } else {
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
                }

                Image(isSelected ? "playerSelectedBackground" : "playerBackground")
                    .resizable()
                    .frame(width: width, height: height)
                    .cornerRadius(10)

                HStack(spacing: 10) {
                    Image(player.character.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: height - 15, height: height - 15)

                    Text(player.character.displayName)
                        .foregroundColor(.title)
                        .fontWeight(isSelected ? .bold : .regular)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.custom("Almendra-Regular", size: 27))

                    Spacer()
                }
                .padding(.horizontal, 8)
                
                if isSelected {
                                    Image("murder_symbol")
                                        .resizable()
                                        .frame(width: 54, height: 57)
                                        .offset(x: 74, y: -36.5) // Metade para fora nas duas direções
                                }
                
            }
        }
        .frame(width: width, height: height)
        .buttonStyle(PlainButtonStyle())
    }
}
