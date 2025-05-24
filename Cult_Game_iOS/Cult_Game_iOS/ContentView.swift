//<<<<<<< HEAD
//import SwiftUI
//
//struct ContentView: View {
//    @ObservedObject private var viewModel = GameViewModel()
//    @State private var selectedCard: Card? = nil
//    @ObservedObject var multiplayerManager = MultiplayerManager.shared
//    @State private var cardPlayedThisRound = false
//    @State private var startPairing = false
//
//    var body: some View {
//        ZStack {
//            VStack {
//                if viewModel.player.role == nil {
//                    
//                    if !startPairing {
//                        
//                    }
//
//                    ProgressView("Waiting for game to start...")
//
////                    Text("Choose your role:")
////                           .font(.title)
////                       Button("Cultist") {
////                           viewModel.selectRole(.cultist)
////                       }.padding()
////                       Button("Heretic") {
////                           viewModel.selectRole(.heretic)
////                       }.padding()
//
//                } else {
//                    Text("\(viewModel.round)")
//
//                    Text(viewModel.player.role == .cultist ? "Faith: \(viewModel.points)" : "Heresy: \(viewModel.points)")
//                    Text("Faithful: \(viewModel.followers)")
//                    
//                    timerView
//                    
//                    // FASE DE JOGO
//                    if case .cardPlay = multiplayerManager.currentPhase {
//                        ScrollView(.horizontal) {
//                            HStack {
//                                ForEach(viewModel.activeCards) { card in
//                                    VStack {
//                                        Image(systemName: "rectangle")
//                                            .resizable()
//                                            .frame(width: 100, height: 100)
//                                        Text(card.name)
//                                        Button("Show") {
//                                            selectedCard = card
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color.gray.opacity(0.2))
//                                    .cornerRadius(8)
//                                }
//                            }
//                        }
//
//
//                        ScrollView(.horizontal) {
//                            HStack {
//                                ForEach(viewModel.player.hand) { card in
//                                    VStack {
//                                        Image(systemName: "rectangle")
//                                            .resizable()
//                                            .frame(width: 100, height: 100)
//                                        Text(card.name)
//                                        Button("Show") {
//                                            selectedCard = card
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color.gray.opacity(0.2))
//                                    .cornerRadius(8)
//                                }
//                            }
//                        }
//
//                        Button("Buy card") {
//                            viewModel.replenishHandIfNeeded()
//                        }
//                        Button("Skip round") {
//                            viewModel.skipCard()
//                        }
//                        .padding()
//                    }
//
//                    // FASE DE DISCUSSÃO
//                    else if case .discussion = multiplayerManager.currentPhase {
//                        Text("Discussion Phase")
//                            .font(.title)
//                            .padding()
//                        Text("This is where players debate their choices.")
//                        Button("Back to Card Play") {
//                            //TODO: Deve ser removido
//                            multiplayerManager.currentPhase = .cardPlay
//                            viewModel.playAllActiveCards()
//                        }
//                        .padding()
//                        Button("Go to Elimination Phase") {
//                            //TODO: Deve ser removido
//                            multiplayerManager.currentPhase = .elimination
//                        }
//                        .padding()
//                    }
//                    else if case .elimination = multiplayerManager.currentPhase {
//                        EliminationView(multiplayerManager: multiplayerManager, viewModel: viewModel)
//                    }
//                    else if case .eliminationResults = multiplayerManager.currentPhase {
//                        EliminationResultsView(viewModel: viewModel)
//                    }
//                }
//            }.onAppear {
//                multiplayerManager.joinSession()
//
//                NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
//                    if let role = notification.object as? PlayerRole {
//                        viewModel.selectRole(role)
//                    }
//                }
//
//            }
//
//            // OVERLAY DE DETALHES DA CARTA
//            if let card = selectedCard {
//                Color.black.opacity(0.5)
//                    .edgesIgnoringSafeArea(.all)
//
//                VStack(spacing: 20) {
//                    Image(systemName: "rectangle")
//                        .resizable()
//                        .frame(width: 150, height: 150)
//                    Text(card.name)
//                        .font(.title)
//                    Text("Faith Cost: \(card.faithCost)")
//                    Text("Follower Effect: \(card.followersEffect)")
//                    Text(card.description)
//                        .padding()
//                        .multilineTextAlignment(.center)
//
//                    HStack {
//                        Button("Use") {
//                            viewModel.playCard(card)
//                            selectedCard = nil
//                        }
//                        .disabled(viewModel.points < card.faithCost)
//                        .padding()
//                        .background(viewModel.points >= card.faithCost ? Color.blue : Color.gray)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//
//                        Button("Close") {
//                            selectedCard = nil
//                        }
//                        .padding()
//                        .background(Color.red)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .padding(40)
//            }
//        }
//    }
//
//    private var timerView: some View {
//        VStack {
//            Text("Phase: \(multiplayerManager.currentPhase)")
//            Text("Time left: \(viewModel.timeRemaining)s")
//                .font(.headline)
//                .padding(8)
//                .background(Color.yellow.opacity(0.3))
//                .cornerRadius(8)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//=======
//>>>>>>> feature/CUL-TV-flow
////import SwiftUI
////
////struct ContentView: View {
////    @ObservedObject private var viewModel = GameViewModel()
////    @State private var selectedCard: Card? = nil
////    @ObservedObject var multiplayerManager = MultiplayerManager.shared
////    @State private var cardPlayedThisRound = false
////    @State private var startPairing = false
////
////    var body: some View {
////        ZStack {
////            VStack {
////                if viewModel.player.role == nil {
////                    ProgressView("Waiting for game to start...")
////
////                } else {
//////                    Text("\(viewModel.round)")
//////
//////                    Text(viewModel.player.role == .cultist ? "Faith: \(viewModel.points)" : "Heresy: \(viewModel.points)")
//////                    Text("Faithful: \(viewModel.followers)")
//////                    
//////                    timerView
////                    
////                    // FASE DE JOGO
////<<<<<<< HEAD
////                    if multiplayerManager.currentPhase == .cardPlay {
////                        PlayCardView()
////                            .environmentObject(viewModel)
////=======
////                    if case .cardPlay = multiplayerManager.currentPhase {
////                        ScrollView(.horizontal) {
////                            HStack {
////                                ForEach(viewModel.activeCards) { card in
////                                    VStack {
////                                        Image(systemName: "rectangle")
////                                            .resizable()
////                                            .frame(width: 100, height: 100)
////                                        Text(card.name)
////                                        Button("Show") {
////                                            selectedCard = card
////                                        }
////                                    }
////                                    .padding()
////                                    .background(Color.gray.opacity(0.2))
////                                    .cornerRadius(8)
////                                }
////                            }
////                        }
////
////
////                        ScrollView(.horizontal) {
////                            HStack {
////                                ForEach(viewModel.player.hand) { card in
////                                    VStack {
////                                        Image(systemName: "rectangle")
////                                            .resizable()
////                                            .frame(width: 100, height: 100)
////                                        Text(card.name)
////                                        Button("Show") {
////                                            selectedCard = card
////                                        }
////                                    }
////                                    .padding()
////                                    .background(Color.gray.opacity(0.2))
////                                    .cornerRadius(8)
////                                }
////                            }
////                        }
////
////                        Button("Buy card") {
////                            viewModel.replenishHandIfNeeded()
////                        }
////                        Button("Skip round") {
////                            viewModel.skipCard()
////                        }
////                        .padding()
////>>>>>>> 76b800c (Alteracoes para fazer vitoria e derrota serem globais enviadas pela TV para iphones todos os casos possiveis de vitoria e derrota)
////                    }
////
////                    // FASE DE DISCUSSÃO
////                    else if case .discussion = multiplayerManager.currentPhase {
////                        Text("Discussion Phase")
////                            .font(.title)
////                            .padding()
////                        Text("This is where players debate their choices.")
////                        Button("Back to Card Play") {
////                            //TODO: Deve ser removido
////                            multiplayerManager.currentPhase = .cardPlay
////                            viewModel.playAllActiveCards()
////                        }
////                        .padding()
////                        Button("Go to Elimination Phase") {
////                            //TODO: Deve ser removido
////                            multiplayerManager.currentPhase = .elimination
////                        }
////                        .padding()
////                    }
////<<<<<<< HEAD
////                    else if multiplayerManager.currentPhase == .elimination {
////                        EliminationView(multiplayerManager: multiplayerManager)
////                    }
////                    else if multiplayerManager.currentPhase == .eliminationResults {
////                        EliminationResultsView()
////=======
////                    else if case .elimination = multiplayerManager.currentPhase {
////                        EliminationView(multiplayerManager: multiplayerManager, viewModel: viewModel)
////                    }
////                    else if case .eliminationResults = multiplayerManager.currentPhase {
////                        EliminationResultsView(viewModel: viewModel)
////>>>>>>> 76b800c (Alteracoes para fazer vitoria e derrota serem globais enviadas pela TV para iphones todos os casos possiveis de vitoria e derrota)
////                    }
////                }
////            }.onAppear {
////                multiplayerManager.joinSession()
////
////                NotificationCenter.default.addObserver(forName: .didReceiveRole, object: nil, queue: .main) { notification in
////                    if let role = notification.object as? PlayerRole {
////                        viewModel.selectRole(role)
////                    }
////                }
////
////            }
////
////            // OVERLAY DE DETALHES DA CARTA
////            if let card = selectedCard {
////                Color.black.opacity(0.5)
////                    .edgesIgnoringSafeArea(.all)
////
////                VStack(spacing: 20) {
////                    Image(systemName: "rectangle")
////                        .resizable()
////                        .frame(width: 150, height: 150)
////                    Text(card.name)
////                        .font(.title)
////                    Text("Faith Cost: \(card.faithCost)")
////                    Text("Follower Effect: \(card.followersEffect)")
////                    Text(card.description)
////                        .padding()
////                        .multilineTextAlignment(.center)
////
////                    HStack {
////                        Button("Use") {
////                            viewModel.playCard(card)
////                            selectedCard = nil
////                        }
////                        .disabled(viewModel.points < card.faithCost)
////                        .padding()
////                        .background(viewModel.points >= card.faithCost ? Color.blue : Color.gray)
////                        .foregroundColor(.white)
////                        .cornerRadius(10)
////
////                        Button("Close") {
////                            selectedCard = nil
////                        }
////                        .padding()
////                        .background(Color.red)
////                        .foregroundColor(.white)
////                        .cornerRadius(10)
////                    }
////                }
////                .padding()
////                .background(Color.white)
////                .cornerRadius(16)
////                .padding(40)
////            }
////        }
////    }
////
////    private var timerView: some View {
////        VStack {
////            Text("Phase: \(multiplayerManager.currentPhase)")
////            Text("Time left: \(viewModel.timeRemaining)s")
////                .font(.headline)
////                .padding(8)
////                .background(Color.yellow.opacity(0.3))
////                .cornerRadius(8)
////        }
////    }
////}
////
////#Preview {
////    ContentView()
////}
