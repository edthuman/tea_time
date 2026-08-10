import AVFoundation
import SwiftUI

class RecorderDelegate: NSObject, AVAudioRecorderDelegate {
    var onFinish: ((Bool) -> Void)?
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.onFinish?(flag)
        }
    }
}

struct AudioRecorder: View {
    @State var recorder: AVAudioRecorder?
    @State var isRecording: Bool = false
    @State var recordingStartTime: Date?
    @State var recorderDelegate = RecorderDelegate()
    
    let maxTimerLength = TimeInterval(5)
    
    func getSoundFileURL() throws -> URL {
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
    
    func getRecorder() {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 22050,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: getSoundFileURL(), settings: settings)
            recorder?.prepareToRecord()
            recorder?.delegate = recorderDelegate
            
        }
        catch {
            // Add better handling of error
            printWithNewlineAbove(input: "Could not initialise AVAudioRecorder: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            Button {
                isRecording = true
                getRecorder()
                
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print("Failed to set up audio session: \(error)")
                    isRecording = false
                    return
                }
                
                let success = recorder?.record(forDuration: maxTimerLength)
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(maxTimerLength))
                    recorder?.stop()
                }
                
                recordingStartTime = Date()

                printWithNewlineAbove(input: "Did start recording: \(success ?? false)")
            } label: {
                Image(systemName: isRecording ? "mic.fill" : "mic")
            }
            .padding(.bottom, 20)
            
            if isRecording {
                HStack(spacing: 10) {
                    Button("Stop") {
                        recorder?.stop()
                        isRecording = false
                        recordingStartTime = nil
                    }
                    
                    if let recordingStartTime = recordingStartTime {
                        TimelineView(
                            .periodic(from: .now, by: 0.1)
                        ) { context in
                            let timeSinceRecordStart = context.date.timeIntervalSince(recordingStartTime)
                                 
//                            if (timeSinceRecordStart < maxTimerLength) {
                                let recordingLength = String(format: "%02.2f", timeSinceRecordStart)
                                Text(recordingLength)
//                            }
//                             } else {
//                                 recorder?.stop()
//                             }
                        }
                    }
                }
            }
            
            AudioPlayer(audioURL: try! getSoundFileURL())
        }
        .onAppear {
            recorderDelegate.onFinish = { _ in
                isRecording = false
                recordingStartTime = nil
            }
        }
    }
}
