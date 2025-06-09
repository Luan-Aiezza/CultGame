//
//  PlayCardViewModel.swift
//  Cult_Game_iOS
//
//  Created by Jorge Samuel Silva Coelho on 21/05/25.
//

import SwiftUI
import Foundation
import GameKit
import Combine

class PlayCardViewModel: ObservableObject, Observable {
    
    @Published var isShowingMurderView = false

    func toggleMurderView() {
        isShowingMurderView.toggle()
    }
   
}
