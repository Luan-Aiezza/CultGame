//
//  PlayCardViewModel.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 21/05/25.
//

import SwiftUI
import Foundation
import MultipeerConnectivity
import Combine

#warning("Dois tipos de observação para a classe")
class PlayCardViewModel: ObservableObject, Observable {
    
    @Published var isShowingMurderView = false

    #warning("Deletar funções não utilizada")
    func toggleMurderView() {
        isShowingMurderView.toggle()
    }
   
}
