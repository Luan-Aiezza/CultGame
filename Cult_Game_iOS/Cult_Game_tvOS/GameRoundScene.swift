import SwiftUI
import SpriteKit

enum GameConditions {
    case heregeVictory(reason: HeregeVictoryReason, character: String)
    case cultVictory(reason: CultVictoryReason)
    
    enum HeregeVictoryReason {
        case fieisZero
        case eliminatedAll
    }
    
    enum CultVictoryReason {
        case fieisMax
        case burnedHerege
    }
}

struct GameRoundView: View {
    let outcome: GameConditions?
    var tvResponse = 1.5
    
    var body: some View {
        ZStack {
            SpriteView(scene: GameStatusView)
                .ignoresSafeArea()
            
            if let outcome = outcome {
                VStack(spacing: 16) {
                    switch outcome {
                    case .heregeVictory(let reason, let character):
                        Text("O culto foi derrotado!")
                            .font(.custom("Almendra-Regular", size: 60*tvResponse))
                            .foregroundColor(Color(red: 227/255, green: 206/255, blue: 167/255))
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                        
                        Text(reason == .fieisZero
                             ? "Já não há almas para sustentar o culto - os fiéis chegaram a zero"
                             : "O Herege serviu heresia como se fosse fé — e vocês beberam até o fim")
                            .font(.custom("Almendra-Regular", size: 24*tvResponse))
                            .foregroundColor(Color(red: 255/255, green: 81/255, blue: 81/255))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        ZStack {
                            Circle()
                                .fill(Color(red: 72/255, green: 11/255, blue: 1/255).opacity(0.86))
                                .frame(width: 160*tvResponse, height: 160*tvResponse)
                                .shadow(color: .red.opacity(0.6), radius: 20)

                            Image("heregeIcon") // Substitua pelo nome correto do asset do herege
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100*tvResponse, height: 100*tvResponse)
                        }
                        
                        Text("Herege - \(character)")
                            .font(.custom("Almendra-Regular", size: 45*tvResponse))
                            .foregroundColor(Color(red: 227/255, green: 206/255, blue: 167/255))
                        
                    case .cultVictory(let reason):
                        Text("O culto continuou soberano!")
                            .font(.custom("Almendra-Regular", size: 60*tvResponse))
                            .foregroundColor(Color(red: 227/255, green: 206/255, blue: 167/255))
                            .multilineTextAlignment(.center)
                        Spacer()
                        
                        Text(reason == .fieisMax
                             ? "Quando o último coração do fiel foi conquistado, os cultistas alcançaram o ápice — e o culto reinou absoluto."
                             : "A chama e a união do culto ardeu mais forte - o herege foi desmascarado")
                            .font(.custom("Almendra-Regular", size: 24*tvResponse))
                            .foregroundColor(Color(red: 211/255, green: 180/255, blue: 125/255))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        if reason == .burnedHerege {
                            Image("cabeca") // Substitua pelo nome correto do asset
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120*tvResponse, height: 120*tvResponse)
                                .padding(.top, 16)
                        }
                    }
                }
                .padding()
            }
        }
    }
}





//UI Condicionais para cada caso de fim de rodada

///Se o herege matou alguem na rodada

///Se queimarem um cultista

///Se os cultistas ganharem (fieis no maximo ou queimarem o herege)

///Se o herege ganhar (fieis no zero ou matar os cultistas
