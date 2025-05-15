
import SwiftUI

struct RoleView: View {
    
    @ObservedObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("background_001")
                    .resizable()
                    .ignoresSafeArea()
                    .overlay {
                        
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                    }
                    .scaledToFill()
                
                
                VStack{
                    HStack(){
                        Spacer()
                        Button {
                            MultiplayerManager.shared.eliminate(peer: viewModel.peerID)
                        } label: {
                            Image("\(viewModel.player.role?.rawValue ?? "cultist")buttonX")
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 35)

                    }
                    
                    VStack {
                        Text("You are a \(viewModel.player.role?.rawValue ?? "Unknown")!")
                            .font(.custom("VinerHandITC", size: 40))
                            .foregroundStyle(Color.title)
                        
                        if let role = viewModel.player.role {
                            switch role {
                            case .cultist:
                                Text("Protect and defend the cult")
                                    .font(.custom("Almendra-Regular", size: 20))
                                    .foregroundStyle(Color.title)
                            case .heretic:
                                Text("Destroy and sabotage the cult")
                                    .font(.custom("Almendra-Regular", size: 20))
                                    .foregroundStyle(Color.titleHeretic)
                            }
                        }
                    }
                    .padding(.top, 90)
                    
                    VStack{
                        if let role = viewModel.player.role {
                                switch role {
                                case .cultist:
                                    Image("\(viewModel.player.role?.rawValue ?? "cultist")_\(viewModel.player.character.rawValue)_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .yellow.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                    
                                case .heretic:
                                    Image("\(viewModel.player.role?.rawValue ?? "heretic")_\(viewModel.player.character.rawValue)_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                
                            }
                        }
                        
                        NavigationLink {
                            ContentView()
                        } label: {
                            ZStack {
                                Image("\(viewModel.player.role?.rawValue ?? "heretic")_button_001")
                                Text("Iniciar")
                                    .foregroundColor(Color.title)
                                    .font(.custom("Almendra-Regular", size: 26))
                            }
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 25)
                }
            }
        }
    } 

}

#Preview {
    RoleView()
}
