import AVFoundation
import SwiftUI

class AudioPlayerManager: NSObject, ObservableObject {
    var audioPlayer: AVAudioPlayer?

    func playAudio(from url: URL) {
        let canAccess = url.startAccessingSecurityScopedResource()
        defer {
            if canAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
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
    
    var audioBookmark: Data?
    

    private func getURLFromBookmark() -> URL? {
        guard let data = audioBookmark else { return nil }
        
        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: data,
                              options: [],
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            
            if isStale {
                // EDTODO - add handling for stale bookmark
            }
            
            return url
        } catch {
            print("Could not resolve bookmark: \(error)")
            return nil
        }
    }
    
    var body: some View {
        Button {
            if audioBookmark == nil {
                return;
            }
            var url: URL?
            if let urlFromBookmark = getURLFromBookmark() {
                url = urlFromBookmark;
            } else {
                return;
            }
            
            guard let url = url else { return }
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
        .disabled(audioBookmark == nil)
    }
}
