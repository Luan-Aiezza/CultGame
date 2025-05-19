import Foundation

extension GameViewModel {
    
    func startTimer() {
        timeRemaining = availableTime
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }

    func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer?.invalidate()
            advancePhaseAfterTimer()
        }
    }
}
