import SwiftUI

struct DraggableCarouselCard: View {
    let card: Card
    let onPullOut: () -> Void
    let onZoom: () -> Void

    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        CardView(card: card)
            .frame(width: 154, height: 216)
            .offset(y: dragOffset.height)
            .scaleEffect(dragOffset != .zero ? 1.05 : 1.0)
            .animation(.spring(), value: dragOffset)
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($dragOffset) { value, state, _ in
                        // Detecta apenas arraste vertical
                        if abs(value.translation.height) > abs(value.translation.width) {
                            state = value.translation
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -80 {
                            onPullOut()
                        }
                    }
            )
            .onTapGesture {
                onZoom()
            }
    }
}
