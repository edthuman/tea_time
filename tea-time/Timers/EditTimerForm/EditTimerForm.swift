import SwiftUI
import CoreData

enum TimePeriods {
    case seconds;
    case minutes;
    case hours;
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
    
    private func resetState() {
        newTimerName = ""
        newTimerLength = "0"
        selectedTimePeriod = .minutes
        newTextColour = .white
        newTimerBackground = .placeholderBackground
        isAdding.toggle()
        appState.setTimerBeingEdited(nil)
        isPresented = false
    }
    
    private func saveChanges () {
        withAnimation {
            let timer: Timer? = appState.timerBeingEdited
  
            let timerName = newTimerName
            
            let textColor = UIColor(newTextColour).cgColor.components
            let textRed = Double(textColor?[0] ?? 0)
            let textGreen = Double(textColor?[1] ?? 0)
            let textBlue = Double(textColor?[2] ?? 0)
            
            let bgColor = UIColor(newTimerBackground).cgColor.components
            let bgRed = Double(bgColor?[0] ?? 0)
            let bgGreen = Double(bgColor?[1] ?? 0)
            let bgBlue = Double(bgColor?[2] ?? 0)
            
            if let timer = timer {
                // Update existing timer
                timer.timerName = timerName

                timer.textRed = textRed
                timer.textGreen = textGreen
                timer.textBlue = textBlue
                
                timer.bgRed = bgRed
                timer.bgGreen = bgGreen
                timer.bgBlue = bgBlue
            } else {
                // Create new timer
                let newItem = Timer(context: viewContext)
                newItem.timerName = timerName
                
                newItem.textRed = textRed
                newItem.textGreen = textGreen
                newItem.textBlue = textBlue
                
                newItem.bgRed = bgRed
                newItem.bgGreen = bgGreen
                newItem.bgBlue = bgBlue
            }
            
            do {
                try viewContext.save()
                resetState()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func addTimer () {
        withAnimation {
            let newItem = Timer(context: viewContext)
            newItem.timerName = newTimerName
            
            let textColor = UIColor(newTextColour).cgColor.components
            newItem.textRed = Double(textColor?[0] ?? 0)
            newItem.textGreen = Double(textColor?[1] ?? 0)
            newItem.textBlue = Double(textColor?[2] ?? 0)
            
            let bgColor = UIColor(newTimerBackground).cgColor.components
            newItem.bgRed = Double(bgColor?[0] ?? 0)
            newItem.bgGreen = Double(bgColor?[1] ?? 0)
            newItem.bgBlue = Double(bgColor?[2] ?? 0)
            
            if let folderId = state.folderId {
                let folder = viewContext.object(with: folderId) as? Folder
                newItem.folder = folder
            }
            
            do {
                try viewContext.save()
                resetState()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
        // Convert to Int first to remove leading zeros
        return String(zeroesRemoved)
    }
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        let timer = appState.timerBeingEdited
        _isAdding = State(initialValue: timer == nil)
        _newTimerName = State(initialValue: timer?.timerName ?? "")
        _newTimerLength = State(initialValue: "\(timer?.seconds ?? 0)")
        _selectedTimePeriod = State(initialValue: .minutes)
        
        if timer != nil {
            _newTextColour = State(initialValue: Color(red: timer!.textRed, green: timer!.textGreen, blue: timer!.textBlue))
            _newTimerBackground = State(initialValue: Color(red: timer!.bgRed, green: timer!.bgGreen, blue: timer!.bgBlue))
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
                        Text("seconds").tag(TimePeriods.seconds)
                        Text("minutes").tag(TimePeriods.minutes)
                        Text("hours").tag(TimePeriods.hours)
                    }
                }
                
                ColorPicker("Text Colour", selection: $newTextColour)
                    .frame(width: screenWidth * 0.45)
                    .padding(.top, 5)
                    .padding(.vertical, 10)
                
                ColorPicker("Background Colour", selection: $newTimerBackground)
                    .frame(width: screenWidth * 0.45)
                    .padding(.vertical, 10)
                
                HStack {
                    Button(action: resetState) {
                        Text("Cancel")
                            .foregroundStyle(.red)
                    }
                    .padding(.trailing, 20)
                    
                    Button(action: saveChanges) {
                        Text("Confirm")
                    }
                }
                .padding(.top, 5)
            }
            .frame(
                width: screenWidth,
                height: screenHeight * 0.95
            )
        }
    }
}
