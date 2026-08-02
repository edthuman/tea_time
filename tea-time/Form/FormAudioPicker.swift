import SwiftUI

struct FormAudioPicker: View {
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
                }
            }
            
            HStack (spacing: 20) {
                Button(
                    audioURL != nil
                       ? "Change"
                       : "Select Audio"
                ) {
                    isPresented = true
                }
                .sheet(isPresented: $isPresented) {
                    AudioPicker(
                        audioURL: $audioURL,
                        audioTooLong: $selectionTooLong,
                        isChanged: $hasChanged
                    )
                }
                
                if audioURL != nil {
                    Button("Remove") {
                        audioURL = nil
                        hasChanged = true
                    }
                    .foregroundStyle(.red)
                }
            }
        }
    }
}
