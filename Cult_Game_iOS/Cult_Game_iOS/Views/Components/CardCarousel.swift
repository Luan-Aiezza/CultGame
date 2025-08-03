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
    
    // MARK: - Dragging state variables added for custom card drag handling
    @State private var isDraggingCard: Bool = false
    @State private var dragCard: Card? = nil
    @State private var dragOffset: CGSize = .zero
    
    
    var body: some View {
        ZStack {
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let dist = abs(distance(index))
                let scale = 1.0 - dist * 0.2
                let z = 1.0 - dist * 0.1
                let xOffset = offset(index)
                
                // Hide card while dragging it separately to avoid duplication
                if !(isDraggingCard && dragCard?.id == card.id) {
                    ZStack {
                        // CardView with custom drag gesture only for the centered card
                        if isCardCentered(index) {
                            CardView(card: card)
                                .frame(width: 154, height: 216)
                                //.draggable(card) // Removed default draggable gesture
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            // Start dragging
                                            isDraggingCard = true
                                            dragCard = card
                                            dragOffset = value.translation
                                        }
                                        .onEnded { value in
                                            // Determine if card dragged far enough to be considered removed
                                            let threshold: CGFloat = 120
                                            if abs(dragOffset.height) > threshold || abs(dragOffset.width) > threshold {
                                                // Remove card from list and set selectedCard
                                                selectedCard = card
                                                if let idx = cards.firstIndex(where: { $0.id == card.id }) {
                                                    cards.remove(at: idx)
                                                }
                                                // Reset dragging state
                                                isDraggingCard = false
                                                dragCard = nil
                                                dragOffset = .zero
                                            } else {
                                                // Cancel drag, reset states
                                                withAnimation {
                                                    dragOffset = .zero
                                                    isDraggingCard = false
                                                    dragCard = nil
                                                }
                                            }
                                        }
                                )
                                // Overlay block if needed on dragged card
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
                                            if vm.points < abs(card.heresyCost) || skippedRound {
                                                ZStack {
                                                    Color.black.opacity(0.6)
                                                        .cornerRadius(12)
                                                    Image("block")
                                                }
                                            }
                                        }
                                    }
                                }
                        } else {
                            // Other cards just normal display with overlay block if needed
                            CardView(card: card)
                                .frame(width: 154, height: 216)
                                //.draggable(card) // Removed default draggable gesture
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
                                            if vm.points < abs(card.heresyCost) || skippedRound {
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
                    }
                    .scaleEffect(scale)
                    .offset(x: xOffset, y: 0)
                    .zIndex(z)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            // Draw the dragged card separately following the finger
            if isDraggingCard, let dragCard = dragCard {
                CardView(card: dragCard)
                    .frame(width: 154, height: 216)
                    .offset(dragOffset)
                    .zIndex(1000)
                    .animation(.easeOut, value: dragOffset)
                    // Overlay block if needed on dragged card
                    .overlay {
                        if let role = vm.player.role {
                            switch role {
                            case .cultist:
                                if vm.points < dragCard.faithCost || skippedRound {
                                    ZStack {
                                        Color.black.opacity(0.6)
                                            .cornerRadius(12)
                                        Image("block")
                                    }
                                }
                            case .heretic:
                                if vm.points < abs(dragCard.heresyCost) || skippedRound {
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
