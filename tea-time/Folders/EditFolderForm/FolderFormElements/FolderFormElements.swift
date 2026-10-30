import SwiftUI

struct FolderFormElements: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    let recorder: AudioRecorder
    let saveChanges: () -> Void
    let resetState: () -> Void
    
    @Binding var newFolderName: String
    @Binding var newTextColour: Color
    @Binding var newFolderBackground: Color
    
    @Binding var audioURL: URL?
    @Binding var audioTooLong: Bool
    @Binding var hasAudioChanged: Bool
    
    var body: some View {
        VStack {
            FormButtonName(
                name: $newFolderName,
                textColour: newTextColour,
                backgroundColour: newFolderBackground
            )
            .frame(maxWidth: screenWidth * 0.39)
            .padding(.top, screenHeight < 500 ? 10 : 0)
            .padding(.bottom, 10)
            
            
            FormColourPicker(
                "Text Colour",
                colour: $newTextColour,
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
            
            FormColourPicker(
                "Background Colour",
                colour: $newFolderBackground,
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
            
            FormAudioPicker(
                audioURL: $audioURL,
                selectionTooLong: $audioTooLong,
                hasChanged: $hasAudioChanged,
                recorder: recorder,
            )
            .padding(.top, 10)
            .padding(.bottom, 8)
            
            FormFinishButtons(
                save: saveChanges,
                disableSave: recorder.status != RecorderStatus.idle,
                cancel: resetState
            )
            .padding(.top, 5)
        }
        .frame(width: screenWidth)
        .frame(maxHeight: .infinity, alignment: .center)
    }
}
