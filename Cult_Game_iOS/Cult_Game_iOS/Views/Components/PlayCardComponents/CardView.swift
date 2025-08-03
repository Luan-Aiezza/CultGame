

//
//  CardView.swift
//  Cult_Game_iOS
//
//  Created by Jessica Rodrigues on 20/05/25.
//

import SwiftUI

struct CardAttribute {
    let value: Int
    let iconName: String
}

struct CardView: View {
    var card: Card
    @State private var cardAttributes: [CardAttribute] = []
    
    var icon: String {
        switch card.type {
        case .common: return "cultist"
        case .cultist: return "cultist"
        case .heresy: return "sabotage"
        case .assassination: return "heresy"
        case .empty: return "cultist"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Card background image
                Image("card_001")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                
                // Card type icon
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: width * 0.15, height: width * 0.15)
                    .padding(.bottom, 3)
                    .position(x: width - (width * 0.8), y: height * 0.12)
                
                // Main card image
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width/2.5, height: height/2.5)
                    .position(x: width / 2, y: height * 0.275)
                
                // Card title
                Text(card.name.capitalized)
                    .font(.custom("VinerHandITC", size: width * 0.08))
                    .foregroundStyle(Color.cardTitle)
                    .frame(width: width * 0.7)
                    .multilineTextAlignment(.center)
                    .position(x: width * 0.5, y: height * 0.530)
                
                // Card description
                Text(card.description)
                    .font(.custom("Almendra-Regular", size: width * 0.055))
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.75)
                    .position(x: width / 2, y: height * 0.7)
                
                // Effects description
                Text(card.effectsDescription)
                    .font(.custom("Almendra-Regular", size: width * 0.045))
                    .foregroundStyle(.black.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.75)
                    .position(x: width / 2, y: height * 0.84)
                
                // Cost display (safe access)
                if cardAttributes.count > 0 {
                    let cost = cardAttributes[0]
                    HStack(spacing: 0) {
                        Text("\(cost.value >= 0 ? "+" : "")\(cost.value)")
                            .font(.custom("VinerHandITC", size: width * 0.075))
                            .foregroundStyle(.black.opacity(0.7))
                       
                        Image(cost.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.08, height: width * 0.06)
                            .padding(.bottom, 3)
                    }
                    .position(x: width * 0.28, y: height * 0.915)
                }
                
                // Effect display (safe access)
                if cardAttributes.count > 1 {
                    let effect = cardAttributes[1]
                    HStack(spacing: 0) {
                        Text("\(effect.value >= 0 ? "+" : "")\(effect.value)")
                            .font(.custom("VinerHandITC", size: width * 0.075))
                            .foregroundStyle(.black.opacity(0.7))

                        Image(effect.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: width * 0.08, height: width * 0.06)
                            .padding(.bottom, 3)
                    }

                    .position(x: width * 0.74, y: height * 0.915)
                }
            }
            .onAppear {
                setupCardAttributes()
            }
        }
    }
    
    private func setupCardAttributes() {
        var attributes: [CardAttribute] = []
        
        if card.followersEffect != 0 {
            attributes.append(CardAttribute(value: card.followersEffect, iconName: "followers"))
        }

        switch card.type {
        case .heresy, .assassination:
            if card.heresyCost != 0 {
                attributes.append(CardAttribute(value: card.heresyCost, iconName: "heresy"))
            }
        case .cultist, .common:
            if card.faithCost != 0 {
                attributes.append(CardAttribute(value: card.faithCost, iconName: "faith"))
            }
        default:
            break
        }

        while attributes.count < 2 {
            attributes.append(CardAttribute(value: 0, iconName: "faith"))
        }
        
        cardAttributes = attributes
    }
}
