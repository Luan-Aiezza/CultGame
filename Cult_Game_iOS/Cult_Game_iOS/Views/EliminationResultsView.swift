import SwiftUI
import MultipeerConnectivity

struct EliminationResultsView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if !viewModel.didEvaluate {
                ProgressView("Calculando eliminação...")
                    .onAppear {
                        viewModel.evaluateVotes()
                    }
            } else {
                if viewModel.isTie {
                    Text("Empate! Ninguém foi eliminado.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                } else if let eliminated = viewModel.eliminatedPlayer,
                          let peerID = multiplayerManager.players[eliminated]?.id {
                    Text("\(peerID) foi eliminado!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Erro ao processar eliminação.")
                }
                
                
                
                Button("Continuar") {
                    // Ação para ir pra próxima etapa do jogo
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
}
