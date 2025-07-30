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

struct CardCarouselView: View {
    @EnvironmentObject var carouselVM: PlayCardViewModel
    var xDistance: Int = 120

    var body: some View {
        ZStack {
            ForEach(Array(carouselVM.cards.enumerated()), id: \.element.id) { index, card in
                let dist = abs(carouselVM.distance(index))
                let scale = 1.0 - dist * 0.2
                let z = 1.0 - dist * 0.1
                let xOffset = carouselVM.offset(index, xDistance: xDistance)

                ZStack {
                    CardView(card: card)
                        .frame(width: 154, height: 216)
                        .draggable(card)
                        .onTapGesture {
                            carouselVM.zoomCard(card)
                        }
                        .overlay {
                            if carouselVM.isCardBlocked(card) {
                                ZStack {
                                    Color.black.opacity(0.6)
                                        .cornerRadius(12)
                                    Image("block")
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
        .onAppear {
            if let vm = carouselVM.vm {
                carouselVM.cards = vm.player.hand
            }
            carouselVM.updateBlockMessage()
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    carouselVM.onDragChanged(value)
                }
                .onEnded { value in
                    withAnimation {
                        carouselVM.onDragEnded(value)
                    }
                }
        )
        .onChange(of: carouselVM.cards.count) { _,_ in
            withAnimation {
                carouselVM.resetCarousel()
            }
        }
    }
}

