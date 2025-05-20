import Foundation
import Combine
import SwiftUI

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int = 90
    @Published var animateTimeWarning: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var warningAnimationTrigger = false

    init() {
        // Roda a cada 1 segundo
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
            .store(in: &cancellables)
    }

    private func tick() {
        guard timeRemaining > 0 else { return }
        timeRemaining -= 1

        // Gatilho para animação quando tempo < 20s
        if timeRemaining <= 20 {
            warningAnimationTrigger.toggle()
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.animateTimeWarning = self.warningAnimationTrigger
                }
            }
        }
    }
}
