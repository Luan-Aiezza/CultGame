import SwiftUI
import MultipeerConnectivity

struct EliminationResultsView: View {
    @ObservedObject var multiplayerManager = MultiplayerManager.shared
    @ObservedObject var viewModel: GameViewModel
    @State private var eliminatedPlayer: MCPeerID?
    @State private var isTie: Bool = false
    @State private var didEvaluate: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            if !didEvaluate {
                ProgressView("Calculando eliminação...")
                    .onAppear {
                        evaluateVotes()
                    }
            } else {
                if isTie {
                    Text("Empate! Ninguém foi eliminado.")
                        .font(.title)
                        .multilineTextAlignment(.center)
                } else if let eliminated = eliminatedPlayer,
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
    
    private func evaluateVotes() {
        let votePairs = multiplayerManager.players.map { (peerID, player) in
            (peerID, player.votes)
        }
        
        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }
        
        if topVoted.count == 1, let toEliminate = topVoted.first {
            viewModel.turnPlayerInactive(to: toEliminate)
            eliminatedPlayer = toEliminate
        } else {
            isTie = true
        }
        
        // Zera os votos de todos os jogadores
        for (peerID, var player) in multiplayerManager.players {
            player.votes = 0
            multiplayerManager.players[peerID] = player
        }
        
        // Envia o estado atualizado para todos os peers
//        multiplayerManager.sendPlayersToAll()
        
        didEvaluate = true
        
        // Será usada assim quando for passada para TV
        
        // Apenas o host deve executar esta lógica
//        guard multiplayerManager.isHosting else {
//            didEvaluate = true
//            return
//        }
//        
//        let votePairs = multiplayerManager.players.map { (peerID, player) in
//            (peerID, player.votes)
//        }
//        
//        let maxVotes = votePairs.map { $0.1 }.max() ?? 0
//        let topVoted = votePairs.filter { $0.1 == maxVotes }.map { $0.0 }
//        
//        if topVoted.count == 1, let toEliminate = topVoted.first {
//            viewModel.turnPlayerInactive(to: toEliminate)
//            eliminatedPlayer = toEliminate
//        } else {
//            isTie = true
//        }
//        
//        // Zera os votos de todos os jogadores
//        for (peerID, var player) in multiplayerManager.players {
//            player.votes = 0
//            multiplayerManager.players[peerID] = player
//        }
//        
//        // Envia o estado atualizado para todos os peers
//        multiplayerManager.sendPlayersToAll()
//        
//        didEvaluate = true
        
        
    }
}
