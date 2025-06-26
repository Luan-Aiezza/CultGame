import SwiftUI
import SpriteKit

struct PlayCardView: View {
    
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var pvm = PlayCardViewModel()
    
    @State private var showMurderView = false
    @State private var showFollowTvView = false
    @State private var showDeadView = false
    @State private var isDisconnected = false
    
    @ViewBuilder
    var destinationView: some View {
        if let outcome = vm.gameOutcome, let role = vm.player.role {
            VictoryScreenView(role: role, outcome: outcome)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if let card = pvm.zoomedCard, pvm.showZoomedCard {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    CardView(card: card)
                        .frame(width: 350, height: 490)
                        .shadow(radius: 10)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                pvm.showZoomedCard = false
                            }
                        }
                        .zIndex(2)
                }
                
                if pvm.showBlockMessage && !pvm.showZoomedCard {
                    blockMessageView(show: $pvm.stringShow)
                        .zIndex(4)
                }
                
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()
                
                VStack {
                    SelectCard()
                        .environmentObject(pvm)
                        .padding(.vertical, 50)
                        .dropDestination(for: Card.self) { items, _ in
                            if let card = items.first {
                                pvm.selectCard(card)
                                return true
                            }
                            return false
                        }
                        .onTapGesture {
                            pvm.returnSelectedCard()
                        }
                        .transition(.slide)
                    
                    if pvm.selectedCard != nil {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(pvm.hand, id: \.id) { card in
                                    CardView(card: card)
                                        .frame(width: 154, height: 216)
                                        .draggable(card)
                                        .overlay {
                                            if pvm.playedCard {
                                                ZStack {
                                                    Color.black.opacity(0.6)
                                                        .cornerRadius(12)
                                                    Image("block")
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .dropDestination(for: Card.self) { _, _ in
                            if let card = pvm.selectedCard {
                                pvm.dropBackCard(card)
                                return true
                            }
                            return false
                        }
                    } else {
                        CardCarouselView()
                            .environmentObject(pvm)
                    }
                    
                    HStack(spacing: 50) {
                        Button {
                            pvm.skipRound()
                        } label: {
                            Image("cardViewButton")
                                .resizable()
                                .frame(width: 124, height: 48)
                        }
                        .disabled(pvm.playedCard || pvm.skippedRound)
                        .opacity((pvm.playedCard || pvm.skippedRound) ? 0.6 : 1.0)
                        
                        Button {
                            if let selectedCard = pvm.selectedCard {
                                print("clicou em done com a carta: \(selectedCard.name)")
                            }
                            pvm.playSelectedCard()
                            
                        } label: {
                            Image("CardDoneButton")
                                .resizable()
                                .frame(width: 124, height: 48)
                        }
                        .disabled(pvm.playedCard || pvm.skippedRound || pvm.selectedCard == nil)
                        .opacity((pvm.playedCard || pvm.skippedRound || pvm.selectedCard == nil) ? 0.6 : 1.0)
                    }
                    .frame(maxWidth: 500)
                    .padding()
                }
                
                if showFollowTvView {
                    FollowTvView()
                        .transition(.opacity)
                        .zIndex(5)
                }
                
                if showDeadView {
                    FollowTvViewDead()
                        .transition(.opacity)
                        .zIndex(10)
                }
                
                NavigationLink(destination: destinationView, isActive: Binding(get: { vm.gameOutcome != nil }, set: { _ in })) {
                    EmptyView()
                }
                
                .fullScreenCover(isPresented: $showMurderView) {
                    MurderView {
                        showMurderView = false
                    }
                }
            }
            .navigationDestination(isPresented: $isDisconnected) {
                PlayView()
            }
        }
        .onAppear {
            pvm.settings(vm: vm)
            pvm.updateMessage()
            
            if vm.player.state == .inactive && !showDeadView {
                showDeadView = true
                multiplayerManager.disconnect()
            }
        }
        .onChange(of: multiplayerManager.currentPhase) { _, newPhase in
            if newPhase == .discussion && vm.player.state == .inactive && !showDeadView {
                showDeadView = true
                multiplayerManager.disconnect()
            } else if newPhase == .discussion && vm.player.state == .active && !showDeadView {
                pvm.stringShow = ""
                pvm.showBlockMessage = false
                showFollowTvView = true
                
                if !pvm.skippedRound && !pvm.playedCard {
                    vm.skipCard()
                    pvm.skippedRound = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        showFollowTvView = true
                    }
                }
            }
        }
    }
}
