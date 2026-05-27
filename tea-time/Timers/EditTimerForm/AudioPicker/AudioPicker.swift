import SwiftUI
import AVFoundation
import UIKit
import UniformTypeIdentifiers

struct AudioPicker: UIViewControllerRepresentable {
    @Binding var audioBookmark: Data?
    @Binding var audioTooLong: Bool
    @Binding var isChanged: Bool
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: false)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: AudioPicker

        init(parent: AudioPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }

            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }

            Task {
                if (await checkAudioLengthValid(url: url)) == false {
                    parent.audioTooLong = true
                    return
                }

                do {
                    let bookmarkData: Data = try url.bookmarkData(
                        options: .minimalBookmark,
                        includingResourceValuesForKeys: nil,
                        relativeTo: nil)

                    parent.audioBookmark = bookmarkData
                    parent.isChanged = true
                } catch {
                    print("Failed to create bookmark: \(error)")
                }
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
