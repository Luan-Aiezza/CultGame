import SwiftUI
import MultipeerConnectivity
import SpriteKit
import AVFoundation

/// BOTAO DE SAIR DA PARTIDA

// tela de vitória para tvOS, exibe elementos visuais com base no resultado da partida
struct VictoryTvView: View {
    let outcome: GameOutcome
    @EnvironmentObject var viewModel: GameViewModel
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
        if let (_, model) = viewModel.multiplayerManager.players.first(where: {$0.value.role == .heretic }) {
            if let character = model.character {
                return "\(character.displayName.capitalized)H"
            }
        }
        
        return nil
    }
    
    // Recupera o nome da imagem de derrota do herege com base no personagem (caso os cultistas tenham vencido)
    var hereticDefeatImageName: String? {
        guard outcome.isCultistVictory else { return nil }
        
        if let model = viewModel.multiplayerManager.players.first(where: { $0.value.role == .heretic })?.value {
            
            if let character = model.character {
                return "Heretic\(character.displayName.capitalized)Died"
            }
        }
        
        return nil
    }
    
    // Retorna o nome formatado do personagem herege (apenas se os hereges vencerem)
    var hereticName: String? {
        guard outcome.isHereticVictory else { return nil }
        if let character = viewModel.multiplayerManager.players
            .first(where: { $0.value.role == .heretic })?
            .value.character {
            return character.rawValue.capitalized
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
                HStack {
                    Spacer()
                    // Botão no canto superior direito para sair da partida e voltar para a tela de espera
                    Button(action: {
                        //VERIFICAR QUEM VEM PRIMEIRO
                        viewModel.resetGame()
                        MultiplayerManager.shared.disconnectAll()
                        viewModel.multiplayerManager.currentPhase = .pairing
                    }) {
                        Image("Exit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 40)
                    }
                    .tint(Color.accentButton)
                    .padding(.trailing, 95)
                    .padding(.bottom, 24)
                }
                
                // Exibe os textos de título e descrição da vitória
                Text(content.title)
                    .font(.custom("VinerHandITC", size: 70))
                    .bold()
                    .foregroundColor(Color(red: 1.0, green: 0.91, blue: 0.75))
                    .multilineTextAlignment(.center)
                    .frame(width: 1086, height: 82.5, alignment: .center) // largura fixa
                    .padding(.horizontal, 24)
                
                Text(content.description)
                    .font(.custom("Almendra-Regular", size: 36))
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
                    .frame(width: 793.5, height: 144)
                    .padding(.horizontal, 32)
                
                Spacer()
                
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
            }
            .padding()
        }.onAppear{
            MainScene.shared?.zoomIn()
            AudioManager.shared.playBackgroundMusic(named: "Background_Map")
        }
    }
}
