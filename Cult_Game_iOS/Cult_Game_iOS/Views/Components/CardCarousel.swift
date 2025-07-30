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


struct CardCarouselView: View {
    var xDistance: Int = 120
    @EnvironmentObject var vm: GameViewModel
    
    @Binding var selectedCard: Card?
    @Binding var zoomedCard: Card?
    @Binding var showZoomedCard : Bool
    @Binding var showBlockMessage : Bool
    @Binding var cards : [Card]
    @Binding var skippedRound : Bool
    @State var snappedItem = 0.0
    @State var draggingItem = 0.0
    @State var activeIndex: Int = 0
    
    
    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let dist = abs(distance(index))
                let scale = 1.0 - dist * 0.2
                let z = 1.0 - dist * 0.1
                let xOffset = offset(index)
                
                ZStack {
                    CardView(card: card)
                        .frame(width: 154, height: 216)
                        .draggable(card)
                        .onTapGesture {
                            withAnimation {
                                zoomedCard = card
                                showZoomedCard = true
                            }
                            
                        }//RESOLVER PARA AS CARTAS QUE USAM HERESY
                        .overlay {
                            if let role = vm.player.role {
                                switch role {
                                case .cultist:
                                    if vm.points < card.faithCost || skippedRound {
                                        ZStack {
                                            Color.black.opacity(0.6)
                                                .cornerRadius(12)
                                            Image("block")
                                        }
                                    }
                                case .heretic:
                                    if vm.globalState.heresyPoints < abs(card.heresyCost) || skippedRound {
                                        ZStack {
                                            Color.black.opacity(0.6)
                                                .cornerRadius(12)
                                            Image("block")
                                        }
                                    }
                                }
                            }
                        }
                    
                }
                .scaleEffect(scale)
                .offset(x: xOffset, y: 0)
                .zIndex(z)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .onAppear(){
            cards = vm.player.hand
            
            let centerIndex = Int(snappedItem).positiveMod(cards.count)
            if cards.indices.contains(centerIndex) {
                let centerCard = cards[centerIndex]
                showBlockMessage = vm.points < centerCard.faithCost
            } else {
                showBlockMessage = false
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    draggingItem = snappedItem + value.translation.width / 100
                }
                .onEnded { value in
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        if cards.count > 0 {
                            draggingItem = round(draggingItem).remainder(dividingBy: Double(cards.count))
                        }
                        snappedItem = draggingItem
                        self.activeIndex = cards.count + Int(draggingItem)
                        if self.activeIndex > cards.count || Int(draggingItem) >= 0 {
                            self.activeIndex = Int(draggingItem)
                        }
                    }
                    let centerIndex = Int(snappedItem).positiveMod(cards.count)
                    let centerCard = cards[centerIndex]
                    
                    if vm.points < centerCard.faithCost {
                        showBlockMessage = true
                    } else {
                        showBlockMessage = false
                    }
                    
                }
        )
        .onChange(of: cards.count) { _ in
            withAnimation {
                snappedItem = 0
                draggingItem = 0
                activeIndex = 0
            }
        }
    }
    
    func distance(_ item: Int) -> Double {
        guard cards.count > 0 else { return 0 }
        return (draggingItem - Double(item)).remainder(dividingBy: Double(cards.count))
    }
    
    
    func offset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(cards.count) * distance(item)
        return sin(angle) * Double(xDistance)
    }
    
    func isCardCentered(_ index: Int) -> Bool {
        return round(draggingItem).remainder(dividingBy: Double(cards.count)) == Double(index)
    }
    
}

