import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - Sound Types
    enum SoundType: String {
        case swipe = "swipe"
        case receiveCard = "receive_card"
        case viewDetails = "view_card"
        case playCard = "play_card"
    }
    
    // MARK: - Play Sound
    func play(_ sound: SoundType) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            print("Sound file \(sound.rawValue).mp3 not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound \(sound.rawValue): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Specific Triggers
    func playSwipeSound() {
        play(.swipe)
    }
    
    func playReceiveCardSound() {
        play(.receiveCard)
    }

    func playViewDetailsSound() {
        play(.viewDetails)
    }

    func playPlayCardSound() {
        play(.playCard)
    }
}


//METODO DE CHAMADA AudioManager.shared.playPlayCardSound()
