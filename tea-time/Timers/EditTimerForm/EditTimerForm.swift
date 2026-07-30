import SwiftUI
import CoreData

enum TimePeriods {
    case seconds
    case minutes
    case hours
}

struct EditTimerForm: View {
    private let fileManager = FileManager.default
    
    @ObservedObject var state = appState
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var isAdding: Bool
    @State private var newTimerName: String
    @State private var newTimerLength: String
    @State private var selectedTimePeriod: TimePeriods
    @State private var newTextColour: Color
    @State private var newTimerBackground: Color
    @State private var showPicker = false

    @State private var audioURL: URL? = nil
    @State private var hasAudioChanged: Bool = false
    @State private var audioTooLong: Bool = false
    
    private func resetState() {
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

                let fileName = getFileNameForTimer(timer: timer)
                saveNotificationSound(fileURL: audioURL, fileName: fileName)

                resetState()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func saveNotificationSound(fileURL: URL?, fileName: String) {
        if hasAudioChanged == false {
            // Prevent re-saving of audio from bookmark when the file is not changed
            return
        }
        
        do {
            let soundFileURL: URL = try getSoundFileURL(fileName: fileName)
                
            guard let url = fileURL else {
                // Sound removed from timer
                try deleteSoundFile(fileName: fileName)
                return
            }
                
            
            if fileManager.fileExists(atPath: soundFileURL.path) {
                _ = try fileManager.replaceItemAt(
                    soundFileURL,
                    withItemAt: url
                )
            } else {
                try fileManager.copyItem(
                    at: url,
                    to: soundFileURL,
                )
            }
        }
        catch {
            printWithNewlineAbove(input: "Failed to create audio file:\n \(error)\n")
        }
    }
    
    private func incrementTimeLength() {
        let currentValue = Int(newTimerLength) ?? 0
        newTimerLength = "\(currentValue + 1)"
    }
    
    private func decrementTimeLength() {
        let currentValue = Int(newTimerLength) ?? 0
        
        if currentValue > 0 {
            newTimerLength = "\(currentValue - 1)"
        }
    }
    
    private func getNewTimerLength(_ timerLength: String) -> String {
        let filtered = timerLength.filter { "0123456789".contains($0) }
        if filtered.isEmpty {
            return "0"
        }
        
        // Removed leading zeroes
        let zeroesRemoved = Int(filtered) ?? 0

        let isTooHigh = zeroesRemoved > 1_000_000
        if isTooHigh {
            return "1000000"
        }
        
        let isTooLow = zeroesRemoved < 0
        if isTooLow {
            return "0"
        }
        return String(zeroesRemoved)
    }
    
    private mutating func intialiseTimerFileURL() {
        let timer = appState.timerBeingEdited
        
        guard let timer = timer else {
            return
        }
        
        do {
            let fileName = getFileNameForTimer(timer: timer)
            let url: URL = try getSoundFileURL(fileName: fileName)
            
            if fileManager.fileExists(atPath: url.path) {
                _audioURL = State(initialValue: url)
            } else {
                _audioURL = State(initialValue: nil)
            }
        }
        catch {
            printWithNewlineAbove(input: "Error initialising sound file URL")
            _audioURL = State(initialValue: nil)
        }
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
            
            HStack {
                Button(action: resetState) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.top, 17)
            .padding(.trailing, 17)

            VStack {
                TextField("Name", text: $newTimerName)
                    .frame(maxWidth: screenWidth * 0.3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(newTextColour)
                    .fontWeight(.bold)
                    .padding(20)
                    .background(
                        newTimerBackground,
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                    .padding(.bottom, 10)
                
                ColorPicker("Text Colour", selection: $newTextColour)
                    .frame(width: screenWidth * 0.45)
                    .padding(.top, 5)
                    .padding(.vertical, 10)
                
                ColorPicker("Background Colour", selection: $newTimerBackground)
                    .frame(width: screenWidth * 0.45)
                    .padding(.top, 10)
                
                HStack (spacing: 20) {
                    Button {
                        decrementTimeLength()
                    } label: {
                        Text("-")
                    }
                    
                    TextField("0", text: $newTimerLength)
                        .onChange(of: newTimerLength) { oldValue, input in
                            newTimerLength = getNewTimerLength(input)
                        }
                      .multilineTextAlignment(.center)
                      .keyboardType(.numberPad)
                      .padding(.leading, 1)
                      .padding(.trailing, 1)
                      .frame(minWidth: 30, idealWidth: nil, maxWidth: nil)
                      .fixedSize()
                    
                    Button {
                        incrementTimeLength()
                    } label: {
                        Text("+")
                    }
                    
                    Picker("", selection: $selectedTimePeriod) {
                        Text(newTimerLength == "1" ? "second" : "seconds")
                            .tag(TimePeriods.seconds)
                        Text(newTimerLength == "1" ? "minute" : "minutes")
                            .tag(TimePeriods.minutes)
                        Text(newTimerLength == "1" ? "hour" : "hours")
                            .tag(TimePeriods.hours)
                    }.fixedSize()
                }
                .padding(.vertical, 20)
                
                HStack (spacing: 10) {
                    Text("Preview audio")
                    
                    if let audioURL = audioURL {
                        AudioPlayer(audioURL: audioURL)
                    }
                }
                .padding(.bottom, 10)
                
                HStack (spacing: 20) {
                    Button(
                        audioURL != nil
                           ? "Change"
                           : "Select Audio"
                    ) {
                        showPicker = true
                    }
                    .sheet(isPresented: $showPicker) {
                        AudioPicker(
                            audioURL: $audioURL,
                            audioTooLong: $audioTooLong,
                            isChanged: $hasAudioChanged
                        )
                    }
                    
                    if audioURL != nil {
                        Button("Remove") {
                            audioURL = nil
                            hasAudioChanged = true
                        }.foregroundStyle(.red)
                    }
                }
                .padding(.bottom, 20)
                
                HStack {
                    Button("Cancel") {
                        resetState()
                    }
                    .foregroundStyle(.red)
                    .padding(.trailing, 20)
                    
                    Button("Confirm") {
                        saveChanges()
                    }
                }
                .padding(.top, 5)
            }
            .frame(
                width: screenWidth,
                height: screenHeight * 0.95
            )
            .alert(isPresented: $audioTooLong) {
                func hideAlert() {
                    audioTooLong = false
                }
                
                return Alert(
                    title: Text("Selected audio was too long"),
                    message: Text(
                        "Notification sounds cannot be longer than 30 seconds"
                    ),
                    dismissButton: .default(
                        Text("But I liked that audio... 😞"),
                        action: hideAlert
                    )
                )
            }
        }
    }
}
