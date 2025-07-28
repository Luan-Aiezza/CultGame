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
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
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
            
            Image("background_002")
                .resizable()
                .overlay {
                    LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                }
                .ignoresSafeArea()
                .scaledToFill()//RETIRAR DEPOIS
            
            FollowTvViewEnd()
        }
        .navigationBarBackButtonHidden(true)
    }
}
