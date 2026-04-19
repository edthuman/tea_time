import AVFoundation
import SwiftUI

class AudioPlayerManager: NSObject, ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playAudio(from url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            // Buffer the file
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            // EDTODO - improve error handling
            print("Playback failed: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
    }
}

struct AudioPlayer: View {
    @StateObject var player = AudioPlayerManager()
    @State var isPlaying: Bool = false
    
    var audioURL: URL?

    var body: some View {
        Button {
            guard let url = audioURL else { return }
            if isPlaying {
                isPlaying.toggle()
                player.stopAudio()
            } else {
                isPlaying.toggle()
                player.playAudio(from: url)
            }
            
        } label: {
            Image(systemName: isPlaying ? "stop.fill" : "play.fill")
        }
        .disabled(audioURL == nil)
    }
}
