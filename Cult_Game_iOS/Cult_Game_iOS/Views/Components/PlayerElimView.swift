//
//  PlayerCellView.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 22/05/25.
//

import SwiftUI

struct PlayerElimView: View {
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
                    if let characterName = player.character?.rawValue {
                        Image(isSelected ? "\(characterName)_heretic" : characterName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: height - 15, height: height - 15)
                    } else {
                        Image("placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: height - 15, height: height - 15)
                    }

                    Text(player.character?.displayName ?? "nil")
                        .foregroundColor(.title)
                        .fontWeight(isSelected ? .bold : .regular)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.custom("Almendra-Regular", size: 27))

                    Spacer()
                }
                .padding(.horizontal, 8)
                
                if isSelected {
                                    Image("fire_symbol")
                                        .resizable()
                                        .frame(width: 46, height: 56)
                                        .offset(x: 62, y: -38.5) // Metade para fora nas duas direções
                                }
                
            }
        }
        .frame(width: width, height: height)
        .buttonStyle(PlainButtonStyle())
    }
}
