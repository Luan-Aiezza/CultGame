//
//  GameTimerManager.swift
//  Cult_Game_tvOS
//
//  Created by Jessica Rodrigues on 22/05/25.
//

import Foundation
import Combine
import SwiftUI

class GameTimerManager: ObservableObject {
    var multiplayerManager = MultiplayerManager.shared
    @Published var timeRemaining: Int = 0
    private var timer: Timer?
    
    var onEnded: (() -> Void)?
    
    func start(duration: Int) {
        stop()
        timeRemaining = duration
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.stop()
                DispatchQueue.main.async { [weak self] in
                    self?.onEnded?()
                }
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset(duration: Int) {
        stop()
        start(duration: duration)
    }
    
    deinit {
        stop()
    }

}
