import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = GameViewModel()
    @State private var selectedCard: Card? = nil
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @State private var roleSelected: Bool = false
    @State private var cardPlayedThisRound = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if viewModel.player.role == nil {
                        ProgressView("waiting for players...")
//                        VStack(spacing: 30) {
//                            Text("Choose your Role")
//                                .font(.largeTitle)
//
//                            Button("Cultist") {
//                                viewModel.selectRole(.cultist)
//                                roleSelected = true
//                            }
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//
//                            Button("Heretic") {
//                                viewModel.selectRole(.heretic)
//                                roleSelected = true
//                            }
//                            .padding()
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
                        }
                     else {
                        VStack {
                            HStack {
                                Text("Round: \(viewModel.round)")
                                    .font(.title2)
                                    .padding(.leading)
                                    .onChange(of: viewModel.round) { _ in
                                        print("🔁 Nova rodada iniciada. Resetando estado de jogo.")
                                        cardPlayedThisRound = false
                                        selectedCard = nil
                                    }
                                Spacer()
                            }

                            VStack {
                                Text("Faith: \(viewModel.globalState.sharedFaithPoints)")
                                    .foregroundColor(.blue)
                                Text("Total Heresy: \(viewModel.globalState.heresyPoints.values.reduce(0, +))")
                                    .foregroundColor(.red)
                                Text("Followers: \(viewModel.globalState.followers)")
                                    .foregroundColor(.green)
                            }
                            .font(.headline)
                            .onAppear {
                                print("👁 Renderizando pontos: Fé = \(viewModel.globalState.sharedFaithPoints), Heresia = \(viewModel.globalState.heresyPoints.values.reduce(0, +)), Fiéis = \(viewModel.globalState.followers))")
                            }

                            Spacer()

                            if viewModel.currentPhase == .cardPlay {
                                VStack(spacing: 16) {
                                    HStack {
                                        ForEach(viewModel.player.hand.prefix(3)) { card in
                                            VStack(spacing: 8) {
                                                Text(card.name)
                                                    .font(.headline)
                                                Text(card.description)
                                                    .font(.caption)
                                                    .multilineTextAlignment(.center)
                                                    .padding(4)

                                                Button("See") {
                                                    selectedCard = card
                                                }
                                                .disabled(viewModel.points < card.faithCost)
                                                .padding(6)
                                                .background(viewModel.points >= card.faithCost ? Color.blue : Color.gray)
                                                .foregroundColor(.white)
                                                .cornerRadius(6)
                                            }
                                            .frame(width: 100)
                                            .padding()
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(12)
                                        }
                                    }

                                    Button("Skip") {
                                        print("⏭ Tentativa de skip na fase cardPlay. Carta jogada: \(cardPlayedThisRound)")
                                        viewModel.skipCard()
                                        viewModel.currentPhase = .discussion
                                    }
                                    .disabled(cardPlayedThisRound)
                                    .padding()
                                    .background(cardPlayedThisRound ? Color.gray.opacity(0.5) : Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)

                                    Button("Teste") {
                                        print("🔬 Botão Teste clicado. Indo para discussão.")
                                        viewModel.currentPhase = .discussion
                                    }
                                    .disabled(!cardPlayedThisRound)
                                    .padding()
                                    .background(cardPlayedThisRound ? Color.green : Color.gray.opacity(0.5))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            } else if viewModel.currentPhase == .discussion {
                                VStack(spacing: 20) {
                                    Text("Discussion Phase")
                                        .font(.title)
                                    Text("This is where players debate their choices.")

                                    Button("Teste") {
                                        print("🔁 Fim da discussão, voltando para cardPlay")
                                        viewModel.currentPhase = .cardPlay
                                        viewModel.playAllActiveCards()
                                    }
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }

                            Spacer()

                            timerView
                                .padding(.bottom)
                        }
                    }
                }
                .onAppear {
                    multiplayerManager.joinSession()

                    NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
                        if let role = notification.object as? PlayerRole {
                            viewModel.selectRole(role)
                        }
                    }

                    NotificationCenter.default.addObserver(forName: .didReceiveGameData, object: nil, queue: .main) { _ in
                        viewModel.objectWillChange.send()
                    }
                }

                if let card = selectedCard {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Image(systemName: "rectangle")
                            .resizable()
                            .frame(width: 150, height: 150)
                        Text(card.name)
                            .font(.title)
                            .foregroundColor(.white)
                        Text("Faith Cost: \(card.faithCost)")
                            .foregroundColor(.white)
                        Text("Follower Effect: \(card.followersEffect)")
                            .foregroundColor(.white)
                        Text(card.description)
                            .padding()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)

                        HStack {
                            Button("Use") {
                                print("🃏 Carta usada: \(card.name)")
                                viewModel.playCard(card)
                                selectedCard = nil
                                cardPlayedThisRound = true
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
                    .background(Color.black)
                    .cornerRadius(16)
                    .padding(40)
                }
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

