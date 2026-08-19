import SwiftUI

struct FormAudioPicker: View {
    @Binding var audioURL: URL?
    @Binding var selectionTooLong: Bool
    @Binding var hasChanged: Bool
    
    @State private var isPresented: Bool = false
    
    var recorder: AudioRecorder
    let recordingURL: URL = getRecordingURL()
    
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

            Button {
                if (recorder.status == .recording) {
                    recorder.stopRecording()
                } else {
                    recorder.startRecording(outputURL: recordingURL)
                }
            } label: {
                Image(
                    systemName: recorder.status == RecorderStatus.recording ? "mic.fill" : "mic"
                )
                .font(.system(size: 16))
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
        .onChange(of: recorder.status ) { oldStatus, newStatus in
            if oldStatus == .recording && newStatus == .idle {
                audioURL = recordingURL
                hasChanged = true
            }
        }
    }
}
