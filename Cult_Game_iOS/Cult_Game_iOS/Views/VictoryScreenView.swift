//
//  VictoryScreenView.swift
//  Cult_Game_iOS
//
//  Created by Grecia Cristina on 20/05/25.
//
/// TODO: eSPACAMENTO ENRE AS LINHAS DE TEXTO
/// BOTAO DE SAIR DA PARTIDA
/// ANIMACAO MASCARA SAINDO
/// ANIMACAO FOGUEIRA 

import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

struct GlowingCircleView: View {
    let characterImageName: String

    @State private var animateGlow = false
    @State private var angle: Double = 0

    let baseColor = Color(red: 0.282, green: 0.043, blue: 0.004) // #480B01

    var body: some View {
        ZStack {

            Image(characterImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 270, height: 300)
                .offset(x: 0, y: 10)

            Circle()
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.red.opacity(0.4),
                            Color.red.opacity(0.9),
                            Color.red.opacity(0.4)
                        ]),
                        startPoint: animateGlow ? .leading : .trailing,
                        endPoint: animateGlow ? .trailing : .leading
                    ),
                    lineWidth: 10
                )
                .frame(width: 300, height: 280)
                .blur(radius: 4)
                .opacity(0.8)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: true), value: animateGlow)

            Circle()
                .fill(Color.white.opacity(0.9))
                .frame(width: 5, height: 9)
                .offset(y: -150)
                .blur(radius: 20)
                .shadow(color: .yellow, radius: 6)
                .rotationEffect(.degrees(angle))
        }
        .onAppear {
            animateGlow = true
            withAnimation(Animation.linear(duration: 9).repeatForever(autoreverses: false)) {
                angle = 360
            }
        }
    }
}


extension GameOutcome {
    var isHereticVictory: Bool {
        self == .hereticVictoryFollowers || self == .hereticVictoryBalance
    }
}



struct VictoryScreenContent {
    let title: String
    let description: String
    let backgroundImageName: String

    
    static func `for`(role: PlayerRole, outcome: GameOutcome) -> VictoryScreenContent {
        switch (role, outcome) {
            
        case (.cultist, .cultistVictoryFollowers),
            (.cultist, .cultistVictoryElimination):
            return .init(
                title: "The Cult Has Triumphed!",
                description: "The flame and unity of the cult burned brighter.",
                backgroundImageName: "CultistVictory"
            )
            
        case (.heretic, .cultistVictoryFollowers),
            (.heretic, .cultistVictoryElimination):
            return .init(
                title: "You Were Discovered!",
                description: "Heresy whispered too much. The cult heard. Now, the veil of lies burns in flames.",
                backgroundImageName: "CultistVictory"
            )
            
        case (.heretic, .hereticVictoryFollowers),
            (.heretic, .hereticVictoryBalance):
            return .init(
                title: "You Have Won!",
                description: "You served heresy as if it were faith — and they drank it to the last drop.",
                backgroundImageName: "HereticVictory"
            )
            
        case (.cultist, .hereticVictoryFollowers),
            (.cultist, .hereticVictoryBalance):
            return .init(
                title: "The Cult Was Defeated!",
                description: "The heretic served heresy as if it were faith — and you drank it to the last drop.",
                backgroundImageName: "HereticVictory"
            )
        }
    }
}

struct VictoryScreenView: View {
        let role: PlayerRole
        let outcome: GameOutcome
        @State private var navigateToWaiting = false
        @ObservedObject var viewModel: GameViewModel
        let hereticRed = Color(red: 1.0, green: 0.32, blue: 0.32) // FF5151
        
        var content: VictoryScreenContent {
            VictoryScreenContent.for(role: role, outcome: outcome)
        }
        
        var hereticImageName: String? {
            // Verifica se a vitória foi dos hereges
            guard outcome.isHereticVictory else { return nil }
            
            // Procura o jogador que é o herege
            if let (peer, model) = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic }) {
                let character = model.character
                return "\(character.rawValue.capitalized)H"
            }
            
            return nil
        }
        
        
        var body: some View {

            ZStack {
                
                Image(content.backgroundImageName)
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                
               
                
                VStack(spacing: 20) {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.resetGame()
                            navigateToWaiting = true
                        }) {
                            Image("exit")
                                .resizable()
                                .frame(width: 65, height: 50)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing,5)
                        .padding(.bottom, 24)
                    }
                    //Spacer()
                    
                    Text(content.title)
                        .font(.custom("VinerHandITC", size: 50))
                        .bold()
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .multilineTextAlignment(.center)
                        
                        .frame(width: 260, alignment: .center) // largura fixa
                        .padding(.horizontal, 24)

                    
                    Text(content.description)
                        .font(.custom("Almendra", size: 24))
                        .foregroundColor({
                            switch outcome {
                            case .hereticVictoryFollowers, .hereticVictoryBalance:
                                return hereticRed
                            default:
                                return Color(red: 1.0, green: 0.91, blue: 0.75)
                            }
                        }())
                        .multilineTextAlignment(.center)
                        .lineSpacing(0.2)
                        .frame(width: 312, alignment: .center)
                        .padding(.horizontal, 32)

                   // Spacer()
//            
//                    SpriteView(scene: scene)
//                        .ignoresSafeArea(.all)
                    
                    
                    
                    
                    
                    
                    
                    
                    // COLOCAR AQUI O FOGO
                    
                    
                    
                    
                    

                    if [.hereticVictoryFollowers, .hereticVictoryBalance].contains(outcome){

                        ZStack {
                            Image("CircleHeretic")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 293)

                            if let imageName = hereticImageName {
                                GlowingCircleView(characterImageName: imageName)
                            }

                        }
                    } else {
                        Image("victory_image_cultist")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Spacer()
                    NavigationLink(destination: WaitingForPlayersView(viewModel: viewModel), isActive: $navigateToWaiting) {
                        EmptyView()
                    }
                    
                }
                .padding()
            }
            .onAppear {
//                print("✅ isHereticVictory: \(outcome.isHereticVictory)")
//                print("🧿 hereticImageName: \(hereticImageName ?? "NIL")")
            }


        }
    }

extension GameViewModel {
    static func previewModel() -> GameViewModel {
        let vm = GameViewModel()
        let peer = MCPeerID(displayName: "You")
        vm.multiplayerManager._setFakePeerID(peer)
        vm.multiplayerManager.connectedPeers = [peer]
        
        var me = PlayerModel()
        me.role = .heretic
        me.character = .fox
        
        vm.multiplayerManager.players[peer] = me
        vm.attPlayer(newPlayer: me) // Garante que o jogador local receba a info
        
        return vm
    }
}


//#Preview("Vitória herege - herege") {
//    VictoryScreenView(
//        role: .heretic,
//        outcome: .hereticVictoryFollowers,
//        viewModel: GameViewModel.previewModel()
//    )
//}
    

    #Preview("Vitória cultista - cultista") {
        VictoryScreenView(
            role: .cultist,
            outcome: .cultistVictoryElimination,
            viewModel: GameViewModel.previewModel()
        )
    }
    
    //#Preview("Vitória cultista - herege") {
    //    VictoryScreenView(
    //        role: .heretic,
    //        outcome: .cultistVictory,
    //        viewModel: GameViewModel.previewModel()
    //    )
    //}
    //#Preview("Vitória herege- cultista") {
    //    VictoryScreenView(
    //        role: .cultist,
    //        outcome: .hereticVictory,
    //        viewModel: GameViewModel.previewModel()
    //    )
    //}

