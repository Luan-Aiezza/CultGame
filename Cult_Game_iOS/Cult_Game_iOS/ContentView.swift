import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    @State private var selectedCard: Card? = nil

    var body: some View {
        ZStack {
            VStack {
                //INTERFACE PARA ESCOLHA DO JOGADOR (PROVISORIO)
                if viewModel.role == nil {
                    Text("Choose your role:")
                        .font(.title)
                    Button("Cultist") {
                        viewModel.selectRole(.cultist)
                    }.padding()
                    Button("Heretic") {
                        viewModel.selectRole(.heretic)
                    }.padding()
                } else {
                    
                    //EXIBIÇÃO DA PONTUAÇÃO DO JOGADOR (PROVISORIO)
                    Text(viewModel.role == .cultist ? "Faith: \(viewModel.points)" : "Heresy: \(viewModel.points)")
                    Text("Faithful: \(viewModel.followers)")

                    //EXIBIÇÃO SIMPLES DAS CARTAS EM UMA SCROLL VIEW (PROVISORIO)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.playerHand) { card in
                                VStack {
                                    Image(systemName: "rectangle") // IMAGEM DA CARTA
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    Text(card.name)
                                    //BOTÃO PARA VER DETLHES DAS CARTAS (PROVISORIO)
                                    Button("Show") {
                                        selectedCard = card
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }

                    //BOTÃO PARA REABASTECER CARTA GASTA ENQUANTO NÃO HÁ RODADAS (PROVISORIO
                    Button("Buy card") {
                        viewModel.replenishCard()
                    }
                    .padding()
                }
            }

            // Detalhe da carta selecionada (overlay)
            if let card = selectedCard {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image(systemName: "rectangle") // IMAGEM DA CARTA
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text(card.name)
                        .font(.title)
                    Text("Cost of \(viewModel.role == .cultist ? "Faith" : "Heresy"): \(card.faithCost)")
                    Text("Faithful: \(card.followersEffect)")
                    Text(card.description)
                        .padding()
                        .multilineTextAlignment(.center)

                    HStack {
                        Button("Use") {
                            viewModel.playCard(card)
                            selectedCard = nil
                        }
                        .disabled(viewModel.points < card.faithCost)
                        .padding()
                        .background(viewModel.points >= card.faithCost ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Close") {
                            selectedCard = nil
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .padding(40)
            }
        }
    }
}

#Preview {
    ContentView()
}
