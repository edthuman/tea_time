import AVFoundation
import SwiftUI

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    private var currentPlayingURL: URL?
    
    override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }
    
    func playAudio(from url: URL) {
        if currentPlayingURL != nil {
            cleanUpAudioResources()
        }
        
        try? AVAudioSession.sharedInstance().setActive(true)
        
        let canAccess = url.startAccessingSecurityScopedResource()
        if canAccess {
            currentPlayingURL = url
        }

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
        
        if let url = currentPlayingURL {
            url.stopAccessingSecurityScopedResource()
            currentPlayingURL = nil
        }
    }
    
    deinit {
        cleanUpAudioResources()
    }
}

struct AudioPlayer: View {
    @StateObject var player = AudioPlayerManager()
    
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
                return
            }
            var url: URL?
            if let urlFromBookmark = getURLFromBookmark() {
                url = urlFromBookmark
            } else {
                return
            }
            
            guard let url = url else { return }
            if player.isPlaying {
                player.stopAudio()
            } else {
                player.playAudio(from: url)
            }
            
        } label: {
            Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
        }
        .disabled(audioBookmark == nil)
    }
}
