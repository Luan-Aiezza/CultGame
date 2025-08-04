import SwiftUI
import SpriteKit

struct PlayCardView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var pvm = PlayCardViewModel()
    @State var selectedCard: Card? = nil
    @State var hand: [Card] = []
    @State var zoomedCard: Card? = nil
    @State var showZoomedCard = false
    @State var showBlockMessage = false
    @State var stringShow = "The cult does not have enough faith points to choose a card"
    @State var skippedRound: Bool = false
    @State var playedCard: Bool = false
    @State private var showMurderView = false
    @State private var selectedPlayerID: String? = nil
    @State private var showFollowTvView = false
    @State private var showDeadView = false
    @State private var isDisconnected = false
    
    @State private var cardPlayedZoomed: Card? = nil
    
    @ViewBuilder
    var destinationView: some View {
        if let outcome = vm.gameOutcome,
           let role = vm.player.role {
            VictoryScreenView(role: role, outcome: outcome)
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                if let card = zoomedCard, showZoomedCard {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                    
                    CardView(card: card)
                        .frame(width: 350, height: 490)
                        .shadow(radius: 10)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                showZoomedCard = false
                            }
                        }
                        .zIndex(2)
                }
                
                if showBlockMessage && !showZoomedCard {
                    blockMessageView(show: $stringShow)
                        .zIndex(4)
                }
                
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()
                    .scaleEffect(1.2)
                
                //CHECAR CONDICIONAL
                VStack {
                    HStack {
                        if let character = vm.player.character {
                            Image(character.displayName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)
                        }
                        Spacer()
                    }
                    .padding([.top, .leading], 24)
                    Spacer()
                }
                .zIndex(10)
                
                VStack {
                    SelectCard(selectedCard: $selectedCard, zoomedCard: $zoomedCard, showZoomedCard: $showZoomedCard)
                        .padding(.vertical, 50)
                        .dropDestination(for: Card.self) { items, location in
                            if let card = items.first {
                                if selectedCard == nil {
                                    selectedCard = card
                                    hand.removeAll { $0 == card }
                                    return true
                                }
                            }
                            return false
                        }
                        .onTapGesture {
                            if let card = selectedCard {
                                if !playedCard {
                                    hand.append(card)
                                    selectedCard = nil
                                }
                            }
                        }
                        .transition(.slide)
                    if selectedCard != nil {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(hand, id: \.id) { card in
                                    CardView(card: card)
                                        .frame(width: 154, height: 216)
                                        .draggable(card)
                                        .overlay {
                                            if playedCard {
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
                        .dropDestination(for: Card.self) { items, location in
                            if let card = selectedCard {
                                hand.append(card)
                                selectedCard = nil
                                return true
                            }
                            return false
                        }
                    } else {
                        CardCarouselView(
                            selectedCard: $selectedCard,
                            zoomedCard: $zoomedCard,
                            showZoomedCard: $showZoomedCard,
                            showBlockMessage: $showBlockMessage,
                            cards: $hand,
                            skippedRound: $skippedRound
                        ).environmentObject(vm)
                    }
                    
                    HStack(spacing: 50) {
                        Button {
                            if !playedCard && selectedCard == nil {
                                vm.skipCard()
                                skippedRound = true
                                stringShow = "You skiped this round!"
                                showBlockMessage = true
                            }
                        } label: {
                            ZStack {
                                Image("cardViewButton")
                                    .resizable()
                                    .frame(width:124,height:48)
                            }
                        }
                        .disabled(playedCard || skippedRound)
                        .opacity((playedCard || skippedRound) ? 0.6 : 1.0)
                        
                        Button {
                            if let selectedCard = selectedCard,
                               let cardToPlay = vm.player.hand.first(where: { $0.id == selectedCard.id }) {
                                if !skippedRound {
                                    vm.playCard(cardToPlay)
                                    stringShow = "You played a card!"
                                    showBlockMessage = true
                                    playedCard = true
                                    cardPlayedZoomed = cardToPlay // 👈 salva a carta para exibir

                                    if cardToPlay.type == .assassination {
                                        showMurderView = true
                                    }
                                }
                            }
                        } label: {
                            Image("CardDoneButton")
                                .resizable()
                                .frame(width:124,height:48)
                        }
                        .disabled(playedCard || skippedRound || selectedCard == nil)
                        .opacity((playedCard || skippedRound || selectedCard == nil) ? 0.6 : 1.0)
                    }
                    .frame(maxWidth: 500)
                    .padding()
                    
                }
                if showFollowTvView {
                    if let card = cardPlayedZoomed{
                        Color.black.opacity(0.6)
                            .ignoresSafeArea()
                            .transition(.opacity)
                        
                        CardView(card: card)
                            .frame(width: 350, height: 490)
                            .shadow(radius: 10)
                            .transition(.scale)
                            .zIndex(6)
                    }else{
                        FollowTvView()
                            .transition(.opacity)
                            .zIndex(5)
                    }
                }
                if showDeadView {
                    FollowTvViewDead()
                        .transition(.opacity)
                        .zIndex(10)
                }
                NavigationLink(
                    destination: destinationView,
                    isActive: Binding(
                        get: { vm.gameOutcome != nil },
                        set: { _ in }
                    )
                ) {
                    EmptyView()
                }
                .fullScreenCover(isPresented: $showMurderView, onDismiss: {
                    selectedPlayerID = nil
                }) {
                    MurderView(onDismiss: { showMurderView = false })
                }
            }
            .navigationDestination(isPresented: $isDisconnected) {
                PlayView()
            }
        }
        .onReceive(multiplayerManager.$currentPhase) { newPhase in
            // Impede que a phase visível vá para .discussion automaticamente
            
            if newPhase == .discussion {
                // Mantenha a fase visível como está
                // print("Tentativa de ir para .discussion ignorada")
            }
        }
        .onAppear {
            self.hand = vm.player.hand
            vm.handlePhaseChange()
            
            //REFATORAR PARA GARANTIR A SAIDA DO JOGADOR MESMO APOS O REINICIO DO JOGO
            if vm.player.state == .inactive && !showDeadView {
                showDeadView = true
                multiplayerManager.disconnect()
            }
            
        }
        .onChange(of: multiplayerManager.currentPhase) { oldValue, newValue in
            
            if newValue == .discussion && vm.player.state == .inactive && !showDeadView {
                showDeadView = true
                multiplayerManager.disconnect()
            }
            
            else if newValue == .discussion && vm.player.state == .active && !showDeadView  {
                
                stringShow = ""
                showBlockMessage = false
                showFollowTvView = true
                
                if !skippedRound && !playedCard {
                    vm.skipCard()
                    skippedRound = true
                }
            }
            // Fechar MurderView se fase mudou para discussão e ninguém foi escolhido
            if newValue == .discussion && showMurderView && selectedPlayerID == nil {
                showMurderView = false
                // Garante que nenhuma eliminação ocorra
                selectedPlayerID = nil
            }
        }
    }
}

#Preview(body: {
    PlayCardView()
        .environmentObject(GameViewModel())
})

