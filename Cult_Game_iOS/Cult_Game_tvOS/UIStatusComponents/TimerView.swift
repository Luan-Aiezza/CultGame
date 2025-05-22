import SwiftUI
import SpriteKit
import Combine

struct TimerView: View {
    
    @StateObject private var timerManager = TimerManager()
    
    var tvResponse = 1.5
    
    var body: some View {
        timerView
    }

    var timerView: some View {
        FontManager.registerFonts()//RETIRAR DAQUI 
        let minutes = timerManager.timeRemaining / 60
        let seconds = timerManager.timeRemaining % 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        return Text(timeString)
            .foregroundColor(timerManager.timeRemaining <= 20 ? .red : Color(red: 0.91, green: 0.91, blue: 0.91))
            .cornerRadius(10)
            .scaleEffect(timerManager.timeRemaining <= 20 && timerManager.animateTimeWarning ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.5), value: timerManager.animateTimeWarning)
    }
}
