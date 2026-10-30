import SwiftUI

struct TimerFormElements: View {
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    
    let recorder: AudioRecorder
    let saveChanges: () -> Void
    let resetState: () -> Void
    
    @Binding var newTimerName: String
    @Binding var newTimerLength: String
    @Binding var selectedTimePeriod: TimePeriods
    @Binding var newTextColour: Color
    @Binding var newTimerBackground: Color
    
    @Binding var audioURL: URL?
    @Binding var audioTooLong: Bool
    @Binding var hasAudioChanged: Bool
    
    var body: some View {
        VStack {
            FormButtonName(
                name: $newTimerName,
                textColour: newTextColour,
                backgroundColour: newTimerBackground
            )
            .frame(maxWidth: screenWidth * 0.39)
            .padding(.top, screenHeight < 500 ? 15 : 0)
            .padding(.bottom, 10)
            
            FormColourPicker(
                "Text Colour",
                colour: $newTextColour,
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
            
            FormColourPicker(
                "Background Colour",
                colour: $newTimerBackground,
                screenWidth: screenWidth,
                screenHeight: screenHeight
            )
            
            HStack (spacing: 20) {
                FormNumber(value: $newTimerLength)
                
                Picker("", selection: $selectedTimePeriod) {
                    Text(newTimerLength == "1" ? "second" : "seconds")
                        .tag(TimePeriods.seconds)
                    Text(newTimerLength == "1" ? "minute" : "minutes")
                        .tag(TimePeriods.minutes)
                    Text(newTimerLength == "1" ? "hour" : "hours")
                        .tag(TimePeriods.hours)
                }.fixedSize()
            }
            .padding(.vertical, 10)
            
            FormAudioPicker(
                audioURL: $audioURL,
                selectionTooLong: $audioTooLong,
                hasChanged: $hasAudioChanged,
                recorder: recorder,
            )
            .padding(.vertical, 12)
            
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
