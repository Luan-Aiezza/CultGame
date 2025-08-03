import SwiftUI

extension Int {
    func positiveMod(_ m: Int) -> Int {
        let r = self % m
        return r < 0 ? r + m : r
    }
}

func blockMessage(cardType : CardType) -> some View {
    ZStack {
        Image("tip_001")
            .resizable()
            .scaledToFit()
            .frame(width: 140)
        
        if cardType == .cultist || cardType == .common {
            Text("O culto não tem pontos de fé suficiente para escolher a carta")
                .font(.custom("Almendra-Regular", size: 16))
                .foregroundColor(Color.title)
                .padding(.horizontal, 8)
        } else {
            Text("Você não tem heresia suficiente para escolher a carta")
                .font(.custom("Almendra-Regular", size: 16))
                .foregroundColor(Color.title)
                .padding(.horizontal, 8)
        }
    }
}

struct blockMessageView : View {
    
    @Binding var show : String
    
    var body: some View {
        ZStack {
            Image("tip_001")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
            Text(show)
                .frame(width: 240)
                .font(.custom("Almendra-Regular", size: 16))
                .foregroundColor(Color.title)
                .padding(.horizontal, 8)
                .padding(.bottom, 15)
                .multilineTextAlignment(.center)
        }
    }
}
