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
    
    var icon : String {
        switch card.type {
        case .common:
            return "common"
        case .cultist:
            return "cultist"
        case .heresy:
            return "sabotage"
        case .assassination:
            return "heresy"
        case .empty:
            return "common"
        }
    }
    
    var costAttribute: CardAttribute? {
        switch card.type {
        case .heresy, .assassination:
            return card.heresyCost > 0 ? CardAttribute(value: card.heresyCost, iconName: "heresy") : nil
        case .cultist, .common:
            return card.faithCost > 0 ? CardAttribute(value: card.faithCost, iconName: "faith") : nil
        default:
            return nil
        }
    }

    var effectAttribute: CardAttribute? {
        if card.followersEffect != 0 {
            return CardAttribute(value: card.followersEffect, iconName: "followers")
        }
        
        if card.faithCost < 0 {
            return CardAttribute(value: abs(card.faithCost), iconName: "faith")
        }
        
        if card.heresyCost < 0 {
            return CardAttribute(value: abs(card.heresyCost), iconName: "heresy")
        }

        return nil
    }

    
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                // Imagem da carta
                Image("card_001")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: width * 0.15, height: width * 0.15)
                    .padding(.bottom, 3)
                    .position(x: width - (width * 0.8), y: height * 0.12)
                
                
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width/2.5, height: height/2.5)
                    .position(x: width / 2, y: height * 0.275)
                
                // Título
                Text(card.name.capitalized)
                    .font(.custom("VinerHandITC", size: width * 0.08))
                    .foregroundStyle(Color.cardTitle)
                    .frame(width: width * 0.7)
                    .multilineTextAlignment(.center)
                    .position(x: width * 0.5, y: height * 0.530)
                
                // Descrição
                Text(card.description)
                    .font(.custom("Almendra-Regular", size: width * 0.055))
                    .foregroundStyle(.black.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.75)
                    .position(x: width / 2, y: height * 0.7)
                
                // Descrição dos Efeitos
                Text(card.effectsDescription)
                    .font(.custom("Almendra-Regular", size: width * 0.045))
                    .foregroundStyle(.black.opacity(0.9))
                    .multilineTextAlignment(.leading)
                    .frame(width: width * 0.75)
                    .position(x: width / 2, y: height * 0.84)
                
                // Custo
                if let cost = costAttribute {
                    HStack(spacing: 0) {
                        Text("-\(cost.value)")
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

                // Efeito
                if let effect = effectAttribute {
                    HStack(spacing: 0) {
                        Text("\(effect.value > 0 ? "+" : "")\(effect.value)")
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
        }
    }
}



#Preview {
    CardView(card: Card(name: "Profanation", faithCost: 0, heresyCost: 10, followersEffect: -10, effectsDescription: "adds faith every round", description: "Whispers about forgotten gods infiltrate among the faithful. Gradually, eyes turn to other altars.", imageName: "card_profanation", type: .heresy, rarity: 1))
        .frame(width: 350, height: 490)
}
