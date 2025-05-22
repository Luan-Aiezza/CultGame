import SwiftUI

struct RoleView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    @State private var fadeInOut : Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("background_002")
                    .resizable()
                    .overlay {
                        LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                    }
                    .ignoresSafeArea()
                    .scaledToFill()
                
                
                VStack{
                    
                    VStack {
                        Text(" \(viewModel.player.role?.rawValue.capitalized ?? "Unknown")")
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
                            if let character = viewModel.player.character {
                                switch role {
                                case .cultist:
                                    Image("\(String(describing: viewModel.player.role?.rawValue))_\(String(describing: viewModel.player.character?.displayName))_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .yellow.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                    
                                case .heretic:
                                    Image("\(viewModel.player.role?.rawValue ?? "heretic")_\(viewModel.player.character!.rawValue)_001")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 250, height: 350)
                                        .shadow(color: .red.opacity(0.4), radius: 5, x: 0, y: 0)
                                        .padding(.bottom, 30)
                                    
                                }
                            }
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 25)
                }
                
                Color.black
                    .opacity(fadeInOut ? 0 : 1)
                    .ignoresSafeArea()
                    .animation(.easeIn(duration: 2), value: fadeInOut)
            }
            .onAppear {
                fadeInOut =  true
            }
        }
    }
}

#Preview {
    RoleView()
        .environment(GameViewModel())
}
