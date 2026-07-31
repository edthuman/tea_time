import SwiftUI
import AVFoundation
import UIKit
import UniformTypeIdentifiers

struct AudioPicker: UIViewControllerRepresentable {
    @Binding var audioURL: URL?
    @Binding var audioTooLong: Bool
    @Binding var isChanged: Bool
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.audio],
            asCopy: true
        )
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: AudioPicker
        var fileURL: URL?

        init(parent: AudioPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileURL = urls.first else { return }

            Task {
                if (await checkAudioLengthValid(url: fileURL)) == false {
                    parent.audioTooLong = true
                    return
                }
                parent.audioURL = fileURL
                parent.isChanged = true
            }
        }
        
        private func checkAudioLengthValid (url: URL) async -> Bool {
            let audioFileDetails = AVURLAsset(url: url)

            do {
                let durationDetails = try await audioFileDetails.load(.duration)
                let duration = CMTimeGetSeconds(durationDetails)
                if duration >= 30.0 {
                    // 30 seconds limit comes from UNNotificationSound
                    return false
                }
                return true
            } catch {
                return false
            }
        }
    }
}
