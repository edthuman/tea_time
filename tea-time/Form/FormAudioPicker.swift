import SwiftUI

func getTestSoundFileURL() throws -> URL {
    let fileManager = FileManager.default
    let documentDirectoryURLs = fileManager.urls(
        for: .documentDirectory,
        in: .userDomainMask
    )

    guard let documentDirectoryURL = documentDirectoryURLs.first else {
        throw FileDirectoryErrors.documentDirectoryNotFound
    }
    let testFile: URL = documentDirectoryURL.appendingPathComponent("test-file.m4a")

    return testFile
}

struct FormAudioPicker: View {
    @State private var recorder = AudioRecorder()
    @Binding var audioURL: URL?
    @Binding var selectionTooLong: Bool
    @Binding var hasChanged: Bool
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack (spacing: 10) {
            if let audioURL = audioURL {
                HStack (spacing: 10) {
                    Text("Preview audio")

                    AudioPlayer(audioURL: audioURL)
                    .disabled(
                        recorder.status == RecorderStatus.recording
                    )
                }
            }
            
            HStack (spacing: 20) {
                Button(
                    audioURL != nil
                       ? "Replace"
                       : "Select Audio"
                ) {
                    isPresented = true
                }
                .disabled(
                    recorder.status == RecorderStatus.recording
                )
                .sheet(isPresented: $isPresented) {
                    AudioPicker(
                        audioURL: $audioURL,
                        audioTooLong: $selectionTooLong,
                        isChanged: $hasChanged
                    )
                }
                
                if audioURL != nil {
                    Button("Remove", role: .destructive) {
                        audioURL = nil
                        hasChanged = true
                    }
                    .disabled(recorder.status == RecorderStatus.recording)
                }
            }
            .padding(.bottom, 10)
            
            let soundFileURL: URL = try! getTestSoundFileURL()
                            
            Button {
                if (recorder.status == .recording) {
                    recorder.stopRecording()
                } else {
                    recorder.startRecording(outputURL: soundFileURL)
                }
            } label: {
                Image(
                    systemName: recorder.status == RecorderStatus.recording ? "mic.fill" : "mic"
                )
                .font(.system(
                    size: 16, weight: .semibold
                ))
                .foregroundStyle(
                    recorder.status == RecorderStatus.recording ? .red : .dynamicBlack
                )
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .stroke(.dynamicBlack, lineWidth: 1)
                )
                .contentShape(Circle())
            }
            .disabled(
                recorder.status == RecorderStatus.transitioning
            )
        }
    }
}
