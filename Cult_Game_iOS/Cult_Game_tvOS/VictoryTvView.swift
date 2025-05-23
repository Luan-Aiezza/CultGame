//
//  VictoryTvView.swift
//  Cult_Game_iOS
//
//  Created by Grecia Cristina on 23/05/25.
//

/// TODO: eSPACAMENTO ENRE AS LINHAS DE TEXTO
/// BOTAO DE SAIR DA PARTIDA


import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation
// View que exibe o personagem herege com um efeito de brilho animado e um círculo pulsante
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
//exibe a imagem do herege derrotado, escurecendo gradualmente e desaparecendo com fade-out
struct HereticDefeatImageView: View {
    let imageName: String

    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: -135, y: -350)
            .frame(width: 150, height: 160)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece imagem
            .opacity(fadeOut) // fade out da imagem
            .onAppear {
                withAnimation(.easeIn(duration: 18)) {
                    darkness = 1.0 // totalmente preto
                }
                withAnimation(.easeOut(duration: 17).delay(2)) {
                    fadeOut = 0.0 // desaparece
                }
            }
    }
}



// Extensão com propriedades auxiliares para verificar se a vitória foi dos hereges ou cultistas
extension GameOutcome {
    var isHereticVictory: Bool {
        self == .hereticVictoryFollowers || self == .hereticVictoryBalance
    }
    var isCultistVictory: Bool {
            self == .cultistVictoryFollowers || self == .cultistVictoryElimination
        }
}


// conteudo da tela de vitória (título, descrição, fundo)

struct VictoryScreenContent {
    let title: String
    let description: String
    let backgroundImageName: String
    

    
    static func `for`(outcome: GameOutcome) -> VictoryScreenContent {
        switch ( outcome) {
            
        case
            ( .cultistVictoryElimination):
            return .init(
                title: "The cult remained dominant",
                description: "The flame and unity of the cult burned brighter – the heretic was unmasked",
                backgroundImageName: "FilterBlack"
                
            )
            
        case ( .cultistVictoryFollowers):
            return .init(
                title: "The cult remained dominan",
                description: "When the last faithful heart was won, the cultists reached their peak — and the cult reigned supreme.",
                backgroundImageName: "FilterBlack"
            )
            
        case ( .hereticVictoryFollowers):
            return .init(
                title: "The cult has been defeated!",
                description: "There are no souls left to sustain the cult – the followers have reached zero.",
                backgroundImageName: "FilterRed"
            )
            
        case
            ( .hereticVictoryBalance):
            return .init(
                title: "The Cult Was Defeated!",
                description: "The heretic served heresy as if it were faith — and you drank it to the last drop.",
                backgroundImageName: "FilterRed"
            )
        }
    }
}
// tela de vitória para tvOS, exibe elementos visuais com base no resultado da partida
struct VictoryTvView: View {
        let outcome: GameOutcome
        @State private var navigateToWaiting = false
        @ObservedObject var viewModel: GameViewModel
        let hereticRed = Color(red: 1.0, green: 0.32, blue: 0.32) // FF5151
        
    //Retorna o conteúdo visual apropriado (título, descrição e fundo) com base no resultado da partida
        var content: VictoryScreenContent {
            VictoryScreenContent.for( outcome: outcome)
        }

    
    
    // Recupera o nome da imagem  do personagem herege (caso ele tenha vencido)
        var hereticImageName: String? {
            // Verifica se a vitória foi dos hereges
            guard outcome.isHereticVictory else { return nil }
            
            // Procura o jogador que é o herege
            if let (_, model) = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic }) {
                let character = model.character
                return "\(character.rawValue.capitalized)H"
            }
            
            return nil
        }
    
    
    
    // Recupera o nome da imagem de derrota do herege com base no personagem (caso os cultistas tenham vencido)
        var hereticDefeatImageName: String? {
        guard outcome.isCultistVictory else { return nil }
        
        if let model = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic })?.value {
            return "Heretic\(model.character.rawValue.capitalized)Died"
        }
        
        return nil
        }
    
    
    // Retorna o nome formatado do personagem herege (apenas se os hereges vencerem)
        var hereticName: String? {
            guard outcome.isHereticVictory else { return nil }
            return viewModel.multiplayerManager.players
                .first(where: { $0.value.role == .heretic })?
                .value.character.rawValue.capitalized
        }
        
    
    
        var body: some View {
            ZStack {
                
                SpriteView(scene: scene)//animacao do fundo
                    .ignoresSafeArea(.all)
                
                Image(content.backgroundImageName)
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                
               
                
                VStack(spacing: 20) {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        // Botão no canto superior direito para sair da partida e voltar para a tela de espera
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
                   
                    
                    
                    // Exibe os textos de título e descrição da vitória

                    Text(content.title)
                        .font(.custom("VinerHandITC", size: 60))
                        .bold()
                        .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                        .multilineTextAlignment(.center)
                        
                        .frame(width: 450, height: 150, alignment: .center) // largura fixa
                        .padding(.horizontal, 24)

                    
                    Text(content.description)
                        .font(.custom("Almendra", size: 30))
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
                        .frame(width: 400, height: 150)
                               //, alignment: .center)
                        .padding(.horizontal, 32)

                    
                    
                    // Exibe o personagem herege vitorioso, com destaque visual e nome
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
                        if let name = hereticName {
                            Text("Heretic – \(name)")
                                .font(.custom("VinerHandITC", size: 30))
                                .bold()
                                .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                                .multilineTextAlignment(.center)
                                .frame(width: 450, height: 150, alignment: .center)
                                .padding(.horizontal, 24)
                        }

                    } else {// Se a vitória foi dos cultistas, mostra a animação de derrota do herege
                        if let defeatImage = hereticDefeatImageName {
                            HereticDefeatImageView(imageName: defeatImage)
                        }

                        
                    }
                    
                    Spacer()
                    NavigationLink(destination: HostGameView(), isActive: $navigateToWaiting) {
                        EmptyView()
                    }// Link para navegar de volta pra tela de host quando o botaao É PRESSIOANDO

                    
                }
                .padding()
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



// Exemplos de visualização da tela de vitóri

//
#Preview("Vitória herege - Followers") {
    VictoryTvView(

        outcome: .hereticVictoryFollowers,
        viewModel: GameViewModel.previewModel()
    )
}
    
//#Preview("Vitória cultista - elimination") {
//    VictoryTvView(
//        
//        outcome: .cultistVictoryElimination,
//        viewModel: GameViewModel.previewModel()
//    )
//}
//#Preview("Vitória herege- mais hereges que cultistas") {
//    VictoryTvView(
//
//        outcome: .hereticVictoryBalance,
//        viewModel: GameViewModel.previewModel()
//    )
//}
////
//#Preview("Vitória cultista - followers") {
//    VictoryTvView(
//        
//        outcome: .cultistVictoryFollowers,
//        viewModel: GameViewModel.previewModel()
//    )
//}
//
