import SwiftUI

struct SelectCard: View {
    @Binding var selectedCard: Card?
    @Binding var zoomedCard: Card?
    @Binding var showZoomedCard : Bool
    
    var body: some View {
        if let card = selectedCard {
            CardView(card: card)
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
                .draggable(card)
                .onTapGesture {
                    withAnimation {
                        zoomedCard = card
                        showZoomedCard = true
                    }
                }
        } else {
            Image("selectCard")
                .resizable()
                .scaledToFit()
                .frame(width: 154, height: 216)
                .padding(.bottom, 100)
        }
    }
}
