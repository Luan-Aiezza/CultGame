import SwiftUI

struct CardCarouselView: View {
    @ObservedObject var viewModel: CardCarouselViewModel
    @EnvironmentObject var vm: GameViewModel

    var body: some View {
        ZStack {
            ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                let dist = abs(viewModel.distance(index))
                let scale = 1.0 - dist * 0.2
                let z = 1.0 - dist * 0.1
                let xOffset = viewModel.offset(index)

                ZStack {
                    CardView(card: card)
                        .frame(width: 154, height: 216)
                        .draggable(card)
                        .cardBlocked(if: card, globalState: vm.multiplayerManager.globalState, skippedRound: viewModel.skippedRound)
                        .onTapGesture {
                            withAnimation {
                                viewModel.zoomedCard = card
                                viewModel.showZoomedCard = true
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
            viewModel.updateCards(from: vm.player.hand)
        }
        .simultaneousGesture(
            DragGesture()
                .onChanged { value in
                    viewModel.onDragChanged(value.translation.width)
                }
                .onEnded { value in
                    viewModel.onDragEnded(value.predictedEndTranslation.width)
                }
        )
        .onChange(of: vm.player.hand.count) { _ in
            viewModel.updateCards(from: vm.player.hand)
        }
    }
}
