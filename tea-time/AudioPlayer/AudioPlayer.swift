import AVFoundation
import SwiftUI

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    private var currentPlayingURL: URL?
    
    func playAudio(from url: URL) {
        if currentPlayingURL != nil {
            cleanUpAudioResources()
        }
        currentPlayingURL = url
        
        try? AVAudioSession.sharedInstance().setActive(true)

        do {
            isPlaying = true
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Playback failed: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        isPlaying = false
        cleanUpAudioResources()
    }
    
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAudio()
    }
    
    private func cleanUpAudioResources() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        if currentPlayingURL != nil {
            currentPlayingURL = nil
        }
    }
    
    deinit {
        cleanUpAudioResources()
    }
}

struct AudioPlayer: View {
    @StateObject var player = AudioPlayerManager()

    var audioURL: URL?
    
    var body: some View {
        Button {
            guard let url: URL = audioURL else { return }

            if player.isPlaying {
                player.stopAudio()
            } else {
                player.playAudio(from: url)
            }
            
        } label: {
            Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
        }
        .disabled(audioURL == nil)
    }
}
