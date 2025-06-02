
/// TODO: eSPACAMENTO ENRE AS LINHAS DE TEXTO
/// BOTAO DE SAIR DA PARTIDA
/// ANIMACAO MASCARA SAINDO
/// ANIMACAO FOGUEIRA

import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

struct VictoryScreenView: View {
    
    let role: PlayerRole
    let outcome: GameOutcome
    @State private var navigateToWaiting = false
    @EnvironmentObject var viewModel: GameViewModel
    let hereticRed = Color(red: 1.0, green: 0.32, blue: 0.32) // FF5151
    @State var isDisconnected = false
    var content: VictoryScreenContent {
        VictoryScreenContent.for(role: role, outcome: outcome)
    }
    
    var hereticImageName: String? {
        // Verifica se a vitória foi dos hereges
        guard outcome.isHereticVictory else { return nil }
        
        // Procura o jogador que é o herege
        if let (_, model) = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic }) {
            let character = model.character
            return "\(String(describing: character?.rawValue.capitalized))H"
        }

        return nil
    }
    var hereticDefeatImageName: String? {
        guard outcome.isCultistVictory else { return nil }
        
        if let model = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic })?.value {
            return "Heretic\(String(describing: model.character?.rawValue.capitalized))DiedIPHONE"
        }
        
        return nil
    }
            
            var body: some View {
                
                
                ZStack {
                    
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
//                                multiplayerManager.disconnect()
//                                isDisconnected = true
                            }) {
                                Image("exit")
                                    .resizable()
                                    .frame(width: 48, height: 35)
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 17.4)
                        }
                        .padding(.top, 16)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack(spacing: 40) {
                        
                        Text(content.title)
                            .font(.custom("VinerHandITC", size: 45))
                            .bold()
                            .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                            .multilineTextAlignment(.center)
                        
                            .frame(width: 260, alignment: .center) // largura fixa
                            .padding(.horizontal, 24)
                            .padding(.top, 80)
                        
                        
                        Text(content.description)
                            .font(.custom("Almendra-Regular", size: 24))
                            .foregroundColor({
                                switch outcome {
                                case .hereticVictoryFollowers, .hereticVictoryBalance:
                                    return hereticRed
                                default:
                                    return Color(red: 211/255, green: 180/255, blue: 125/255, opacity: 1)
                                }
                            }())
                            .multilineTextAlignment(.center)
                            .lineSpacing(0.2)
                            .frame(width: 312, alignment: .center)
                            .padding(.horizontal, 32)
                        
                        
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
                            
                            if let defeatImage = hereticDefeatImageName {
                                HereticDefeatImageViewiphone(imageName: defeatImage)
                            }
                        }
                        
                        Spacer()
                        
                        
                    }.navigationDestination(isPresented: $isDisconnected) {
                        PlayView()
                    }
                    .padding()
                }
                .onAppear {
                }
            }
        }
        
struct HereticDefeatImageViewiphone: View {
    let imageName: String
    
    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: 0, y: -120)
            .frame(width: 115, height: 130)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece imagem
            .opacity(fadeOut) // fade out da imagem
            .onAppear {
                withAnimation(.easeIn(duration: 8)) {
                    darkness = 1.0 // totalmente preto
                }
                withAnimation(.easeOut(duration: 15).delay(2)) {
                    fadeOut = 0.0 // desaparece
                }
            }
    }
}
extension GameViewModel {
    static func previewModel() -> GameViewModel {
        let vm = GameViewModel()
        let peer = MCPeerID(displayName: "You")
        //vm.multiplayerManager.setFakePeerID()
        vm.multiplayerManager.connectedPeers = [peer]

        var me = PlayerModel()
        me.role = .heretic
        me.character = .deer

        vm.multiplayerManager.players[peer.displayName] = me
        vm.attPlayer(newPlayer: me)

        // ✅ Adiciona o herege
        let hereticPeer = MCPeerID(displayName: "Herege")
        let heretic = PlayerModel(
            id: hereticPeer.displayName,
            role: .heretic,
            state: .active,
            character: .fox
        )
        vm.multiplayerManager.players[hereticPeer.displayName] = heretic
        vm.multiplayerManager.connectedPeers.append(hereticPeer)

        return vm
    }
}
struct DefeatedImageView: View {
    let imageName: String
    
    @State private var darkness: Double = 0.0
    @State private var fadeOut: Double = 1.0
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .offset(x: 0, y: -120)
            .frame(width: 115, height: 130)
            .position(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            .colorMultiply(Color(white: 1.0 - darkness)) // escurece imagem
            .opacity(fadeOut) // fade out da imagem
            .onAppear {
                withAnimation(.easeIn(duration: 8)) {
                    darkness = 1.0 // totalmente preto
                }
                withAnimation(.easeOut(duration: 15).delay(2)) {
                    fadeOut = 0.0 // desaparece
                }
            }
    }
}
