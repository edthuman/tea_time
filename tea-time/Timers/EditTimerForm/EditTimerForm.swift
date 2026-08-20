import SwiftUI
import CoreData

enum TimePeriods {
    case seconds
    case minutes
    case hours
}

struct EditTimerForm: View {
    @ObservedObject var state = appState
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var isAdding: Bool
    @State private var newTimerName: String
    @State private var newTimerLength: String
    @State private var selectedTimePeriod: TimePeriods
    @State private var newTextColour: Color
    @State private var newTimerBackground: Color
    
    @State private var audioURL: URL? = nil
    @State private var recorder = AudioRecorder()
    @State private var showAudioPicker = false
    @State private var hasAudioChanged: Bool = false
    @State private var audioTooLong: Bool = false
    
    private func resetState() {
        if recorder.status == .recording {
            recorder.stopRecording()
        }
        clearTemporaryDirectory()
        
        newTimerName = ""
        newTimerLength = "1"
        selectedTimePeriod = .minutes
        newTextColour = .white
        newTimerBackground = .placeholderBackground
        isAdding.toggle()
        appState.setTimerBeingEdited(nil)
        isPresented = false
        hasAudioChanged = false
        audioURL = nil
    }
    
    private func getSecondsFromInput() -> Int64 {
        let lengthInput = Int64(newTimerLength) ?? 0
        
        if selectedTimePeriod == .seconds {
            return lengthInput
        } else if selectedTimePeriod == .minutes {
            return lengthInput * 60
        } else {
            return lengthInput * 60 * 60
        }
    }

    private func saveChanges () {
        withAnimation {
            var timer: Timer? = appState.timerBeingEdited

            if timer == nil {
                let newItem = Timer(context: viewContext)
                
                var folder: Folder?
                if let folderId = state.folderId {
                    folder = viewContext.object(with: folderId) as? Folder
                }
                newItem.folder = folder
                timer = newItem
            }
            guard let timer = timer else {
                return
            }
            
            timer.timerName = newTimerName
            timer.seconds = getSecondsFromInput()

            // Text colour
            let textColor = UIColor(newTextColour).cgColor.components
            let textRed = Double(textColor?[0] ?? 0)
            let textGreen = Double(textColor?[1] ?? 0)
            let textBlue = Double(textColor?[2] ?? 0)
            timer.textRed = textRed
            timer.textGreen = textGreen
            timer.textBlue = textBlue
            
            // Background colour
            let bgColor = UIColor(newTimerBackground).cgColor.components
            let bgRed = Double(bgColor?[0] ?? 0)
            let bgGreen = Double(bgColor?[1] ?? 0)
            let bgBlue = Double(bgColor?[2] ?? 0)
            
            timer.bgRed = bgRed
            timer.bgGreen = bgGreen
            timer.bgBlue = bgBlue
            
            do {
                try viewContext.save()

                let fileName = getFileName(timer)
                saveNotificationSound(fileURL: audioURL, fileName: fileName, hasAudioChanged: hasAudioChanged)

                resetState()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
        
    private mutating func intialiseTimerFileURL() {
        let timer = appState.timerBeingEdited
        let fileURL = getItemSoundURL(timer)
        _audioURL = State(initialValue: fileURL)
    }
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        let timer = appState.timerBeingEdited
        
        if let timer = timer {
            let seconds = timer.seconds
            if seconds % 3600 == 0 {
                // Hours
                _newTimerLength = State(initialValue: "\(seconds / 3600)")
                _selectedTimePeriod = State(initialValue: .hours)
            } else if seconds > 0 && seconds % 60 == 0 {
                // Minutes
                _newTimerLength = State(initialValue: "\(seconds / 60)")
                _selectedTimePeriod = State(initialValue: .minutes)
            } else {
                // Seconds
                _newTimerLength = State(initialValue: "\(seconds)")
                _selectedTimePeriod = State(initialValue: .seconds)
            }
        } else {
            _newTimerLength = State(initialValue: "1")
            _selectedTimePeriod = State(initialValue: .minutes)
        }
        
        _isAdding = State(initialValue: timer == nil)
        _newTimerName = State(initialValue: timer?.timerName ?? "")
        
        if let timer = timer {
            _newTextColour = State(initialValue: Color(red: timer.textRed, green: timer.textGreen, blue: timer.textBlue))
            _newTimerBackground = State(initialValue: Color(red: timer.bgRed, green: timer.bgGreen, blue: timer.bgBlue))
            intialiseTimerFileURL()
        } else {
            _newTextColour = State(initialValue: .white)
            _newTimerBackground = State(initialValue: .placeholderBackground)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            CloseButton(close: resetState)

            VStack {
                FormButtonName(
                    name: $newTimerName,
                    textColour: newTextColour,
                    backgroundColour: newTimerBackground
                )
                .frame(maxWidth: screenWidth * 0.39)
                .padding(.bottom, 10)
                
                FormColourPicker("Text Colour", colour: $newTextColour)
                    .frame(width: screenWidth * 0.45)
                
                FormColourPicker("Background Colour", colour: $newTimerBackground)
                    .frame(width: screenWidth * 0.45)
                
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
            .frame(
                width: screenWidth,
                height: screenHeight * 0.95
            )
            .audioTooLongAlert(isPresented: $audioTooLong)
        }
        .onDisappear {
            if recorder.status == .recording {
                recorder.stopRecording()
            }
            
            clearTemporaryDirectory()
        }
    }
}
