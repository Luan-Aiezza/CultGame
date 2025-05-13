import SwiftUI

struct ContentView: View {
//    @ObservedObject private var viewModel = GameViewModel()
    @ObservedObject private var viewModel = GameViewModel()
    @State private var selectedCard: Card? = nil
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.role == nil {
                    
//                    ProgressView("Waiting for game to start...")
                    
                    Text("Choose your role:")
                           .font(.title)
                       Button("Cultist") {
                           viewModel.selectRole(.cultist)
                       }.padding()
                       Button("Heretic") {
                           viewModel.selectRole(.heretic)
                       }.padding()

                } else {
                    Text("\(viewModel.round)")
                    
                    Text(viewModel.role == .cultist ? "Faith: \(viewModel.points)" : "Heresy: \(viewModel.points)")
                    Text("Faithful: \(viewModel.followers)")
        

                    // TIMER
                    timerView

                    // FASE DE JOGO
                    if viewModel.currentPhase == .cardPlay {
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.activeCards) { card in
                                    VStack {
                                        Image(systemName: "rectangle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                        Text(card.name)
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
                        
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.playerHand) { card in
                                    VStack {
                                        Image(systemName: "rectangle")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                        Text(card.name)
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

                        Button("Buy card") {
                            viewModel.replenishHandIfNeeded()
                        }
                        Button("Skip round") {
                            viewModel.skipCard()
                        }
                        .padding()
                    }

                    // FASE DE DISCUSSÃO
                    else if viewModel.currentPhase == .discussion {
                        Text("Discussion Phase")
                            .font(.title)
                            .padding()
                        Text("This is where players debate their choices.")
                        Button("Back to Card Play") {
                            viewModel.currentPhase = .cardPlay
                            viewModel.playAllActiveCards()
                        }
                        .padding()
                    }
                }
            }.onAppear {
                multiplayerManager.joinSession()
                
                NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                    if let role = notification.object as? PlayerRole {
                        viewModel.selectRole(role)
                    }
                }
                
                for family in UIFont.familyNames {
                    print("Family: \(family)")
                    for name in UIFont.fontNames(forFamilyName: family) {
                        print("  Font: \(name)")
                    }
                }
                
            }

            // OVERLAY DE DETALHES DA CARTA
            if let card = selectedCard {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Image(systemName: "rectangle")
                        .resizable()
                        .frame(width: 150, height: 150)
                    Text(card.name)
                        .font(.title)
                    Text("Faith Cost: \(card.faithCost)")
                    Text("Follower Effect: \(card.followersEffect)")
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

    private var timerView: some View {
        Text("Time left: \(viewModel.timeRemaining)s")
            .font(.headline)
            .padding(8)
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(8)
    }
}

#Preview {
    ContentView()
}
