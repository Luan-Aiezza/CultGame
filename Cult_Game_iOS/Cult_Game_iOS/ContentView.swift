
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        VStack {
            if viewModel.role == nil {
                Text("Escolha seu papel")
                    .font(.title)
                Button("Cultista") {
                    viewModel.selectRole(.cultist)
                }.padding()
                Button("Herege") {
                    viewModel.selectRole(.heretic)
                }.padding()
            } else {
                Text(viewModel.role == .cultist ? "Fé: \(viewModel.points)" : "Heresia: \(viewModel.points)")
                Text("Seguidores: \(viewModel.followers)")

                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.playerHand) { card in
                            VStack {
                                Image(systemName: "rectangle") // Substitua por card.imageName
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                Text(card.name)
                                Text(viewModel.role == .cultist ? "Fé: \(card.faithCost)" : "Heresia: \(card.faithCost)")
                                Text("Seguidores: \(card.followersEffect)")
                                Button("Usar") {
                                    viewModel.playCard(card)
                                }
                                .disabled(viewModel.points < card.faithCost)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                }

                HStack {
                    Button("Reabastecer Carta") {
                        viewModel.replenishCard()
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
