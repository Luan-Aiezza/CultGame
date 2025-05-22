import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = GameViewModel()
    @State private var selectedCard: Card? = nil
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var cardPlayedThisRound = false
    @State private var startPairing = false

    var body: some View {
        ZStack {
            VStack {
                if viewModel.player.role == nil {
                    ProgressView("Waiting for game to start...")

                } else {
//                    Text("\(viewModel.round)")
//
//                    Text(viewModel.player.role == .cultist ? "Faith: \(viewModel.points)" : "Heresy: \(viewModel.points)")
//                    Text("Faithful: \(viewModel.followers)")
//                    
//                    timerView
                    
                    // FASE DE JOGO
                    if multiplayerManager.currentPhase == .cardPlay {
                        PlayCardView()
                            .environmentObject(viewModel)
                    }

                    // FASE DE DISCUSSÃO
                    else if multiplayerManager.currentPhase == .discussion {
                        Text("Discussion Phase")
                            .font(.title)
                            .padding()
                        Text("This is where players debate their choices.")
                        Button("Back to Card Play") {
                            //TODO: Deve ser removido
                            multiplayerManager.currentPhase = .cardPlay
                            viewModel.playAllActiveCards()
                        }
                        .padding()
                        Button("Go to Elimination Phase") {
                            //TODO: Deve ser removido
                            multiplayerManager.currentPhase = .elimination
                        }
                        .padding()
                    }
                    else if multiplayerManager.currentPhase == .elimination {
                        EliminationView(multiplayerManager: multiplayerManager)
                    }
                    else if multiplayerManager.currentPhase == .eliminationResults {
                        EliminationResultsView()
                    }
                }
            }.onAppear {
                multiplayerManager.joinSession()

                NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                    if let role = notification.object as? PlayerRole {
                        viewModel.selectRole(role)
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
        VStack {
            Text("Phase: \(multiplayerManager.currentPhase)")
            Text("Time left: \(viewModel.timeRemaining)s")
                .font(.headline)
                .padding(8)
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(8)
        }
    }
}

#Preview {
    ContentView()
}
