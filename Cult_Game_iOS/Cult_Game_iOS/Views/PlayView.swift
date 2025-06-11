import SpriteKit
import SwiftUI
import GameKit

struct PlayView: View {
    @EnvironmentObject var vm: GameViewModel
    @ObservedObject var multiplayer = GameKitMultiplayerManager.shared
    
    @State private var isAuthenticated = false
    @State private var isAuthenticating = true
    @State private var authError: String?

    var body: some View {
        NavigationStack {
            ZStack {
                // Fundo com a cena do SpriteKit
                SpriteView(scene: scene)
                    .ignoresSafeArea()
                
                // Camada de gradiente radial para escurecer a tela
                RadialGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.4), Color.black]),
                    center: .center,
                    startRadius: 10,
                    endRadius: 300
                )
                .ignoresSafeArea()
                
                VStack {
                    Image("TitleGamePhone")
                        .resizable()
                        .frame(width: 309, height: 154)

                    Spacer()
                    
                    if isAuthenticating {
                        ProgressView("Autenticando...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                            .padding()
                    } else if let error = authError {
                        Text("Erro: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    ZStack {
                        Image("cultist_button_001")
                            .resizable()
                            .frame(width: 200, height: 51)
                        
                        NavigationLink {
                            GameView()
                                .environmentObject(vm)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Pair")
                                .font(.custom("Almendra-Regular", size: 26))
                                .foregroundStyle(Color.title)
                        }
                        .disabled(!isAuthenticated)
                        .opacity(isAuthenticated ? 1.0 : 0.5)
                    }
                }
                .padding(.bottom)
                .padding(.top, 104)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            authenticatePlayer()
        }
    }

    private func authenticatePlayer() {
        isAuthenticating = true
        multiplayer.authenticateLocalPlayer { success in
            DispatchQueue.main.async {
                isAuthenticated = success
                isAuthenticating = false
                if !success {
                    authError = "Não foi possível autenticar com o Game Center. Verifique sua conexão ou o login no Game Center."
                }
            }
        }
    }
}
