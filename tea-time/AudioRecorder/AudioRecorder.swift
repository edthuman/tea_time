import AVFoundation
import SwiftUI

@Observable
class AudioRecorder {
    private var engine = AVAudioEngine()
    private var audioFile: AVAudioFile?
    
    var status: RecorderStatus = RecorderStatus.idle
    var framesRecorded: AVAudioFrameCount = 0
    var maximumFrames: AVAudioFrameCount = 0
    
    func startRecording(outputURL: URL) {
        status = RecorderStatus.transitioning
        framesRecorded = 0
        let session = AVAudioSession.sharedInstance()
        
        do {
        try session.setActive(true)

        let format = engine.inputNode.outputFormat(forBus: 0)
        maximumFrames = AVAudioFrameCount(30.0 * format.sampleRate)
        
            audioFile = try AVAudioFile(
                forWriting: outputURL,
                settings: format.settings
            )
            
            engine.reset()
            engine.inputNode.removeTap(onBus: 0)
            engine.inputNode.installTap(
                onBus: 0,
                bufferSize: 4096,
                format: format,
                block: { buffer, time in
                    let bufferLength = buffer.frameLength
                    
                    let unusableBuffer = self.framesRecorded >= self.maximumFrames
                    if (unusableBuffer) {
                        return
                    }
                    
                    let maxLengthExceeded = self.framesRecorded + bufferLength > self.maximumFrames
                    if (maxLengthExceeded) {
                        // Save partial buffer to audio file
                        let requiredFrames = AVAudioFrameCount(self.maximumFrames - self.framesRecorded)
                        buffer.frameLength = requiredFrames
                    }
                    
                    do {
                        try self.audioFile?.write(from: buffer)
                        self.framesRecorded += buffer.frameLength
                        
                        if (self.framesRecorded >= self.maximumFrames) {
                            DispatchQueue.main.async {
                                self.stopRecording()
                            }
                        }
                    } catch {
                        printWithNewlineAbove(input: "Failed to write to file: \(error)")
                    }
                }
            )
            try engine.start()
            status = RecorderStatus.recording
        } catch {
            status = RecorderStatus.idle
            print("Failed to create file: \(error)")
            return
        }
    }
    
    func stopRecording() {
        status = RecorderStatus.transitioning
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        audioFile = nil
        status = RecorderStatus.idle
    }
}
