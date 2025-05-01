
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
//            Text("Fé: \(viewModel.faithPoints)")
//            Text("Seguidores: \(viewModel.followers)")

            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.playerHand) { card in
                        VStack {
                            Image(card.imageName)
                                .resizable()
                                .frame(width: 100, height: 100)
//                            Text(card.name)
//                            Text("Fé: \(card.faithCost)")
//                            Text("+\(card.followersGained) seguidores")
//                            Button("Usar") {
//                                viewModel.playCard(card)
//                            }
//                            .disabled(viewModel.faithPoints < card.faithCost)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
            }

            HStack {
                Button("Receber Cartas") {
                    viewModel.receiveInitialCards()
                }
                .padding()

//                Button("Reabastecer Carta") {
//                    viewModel.replenishCard()
//                }
//                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
