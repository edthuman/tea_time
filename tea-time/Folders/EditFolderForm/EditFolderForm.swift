import SwiftUI
import CoreData

struct FolderFormData: Codable, HasFormType {
    var formType = FormType.Folder
    var isAdding: Bool
    var folderName: String
    var textRed: Double
    var textGreen: Double
    var textBlue: Double
    var folderBackgroundRed: Double
    var folderBackgroundGreen: Double
    var folderBackgroundBlue: Double
    var audioURL: URL?
    var hasAudioChanged: Bool
}

struct EditFolderForm: View {
    @ObservedObject var state = appState
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var isAdding: Bool
    @State private var newFolderName: String
    @State private var newTextColour: Color
    @State private var newFolderBackground: Color
    
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

        newFolderName = ""
        newTextColour = .white
        newFolderBackground = .placeholderBackground
        isAdding.toggle()
        appState.setFolderBeingEdited(nil)
        isPresented = false
        hasAudioChanged = false
        audioURL = nil
    }
    
    private mutating func intialiseFolderFileURL() {
        let folder = appState.folderBeingEdited
        let fileURL = getItemSoundURL(folder)
        _audioURL = State(initialValue: fileURL)
    }
    
    private func saveChanges () {
        withAnimation {
            var folder: Folder? = appState.folderBeingEdited
  
            let folderName = newFolderName
            
            let textColor = UIColor(newTextColour).cgColor.components
            let textRed = Double(textColor?[0] ?? 0)
            let textGreen = Double(textColor?[1] ?? 0)
            let textBlue = Double(textColor?[2] ?? 0)
            
            let bgColor = UIColor(newFolderBackground).cgColor.components
            let bgRed = Double(bgColor?[0] ?? 0)
            let bgGreen = Double(bgColor?[1] ?? 0)
            let bgBlue = Double(bgColor?[2] ?? 0)
            
            if let folder = folder {
                // Update existing folder
                folder.folderName = folderName

                folder.textRed = textRed
                folder.textGreen = textGreen
                folder.textBlue = textBlue
                
                folder.bgRed = bgRed
                folder.bgGreen = bgGreen
                folder.bgBlue = bgBlue
            } else {
                // Create new folder
                let newItem = Folder(context: viewContext)
                newItem.folderName = folderName
                
                newItem.textRed = textRed
                newItem.textGreen = textGreen
                newItem.textBlue = textBlue
                
                newItem.bgRed = bgRed
                newItem.bgGreen = bgGreen
                newItem.bgBlue = bgBlue
                folder = newItem
            }
            
            do {
                try viewContext.save()
                
                if let folder = folder {
                    let fileName = getFileName(folder)
                    saveNotificationSound(fileURL: audioURL, fileName: fileName, hasAudioChanged: hasAudioChanged)
                }
                
                resetState()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func getFormData() -> Data? {
        // Text colour
        let textColor = UIColor(newTextColour).cgColor.components
        let textRed = Double(textColor?[0] ?? 0)
        let textGreen = Double(textColor?[1] ?? 0)
        let textBlue = Double(textColor?[2] ?? 0)
        
        // Background colour
        let folderBackgroundColor = UIColor(newFolderBackground).cgColor.components
        let folderBackgroundRed = Double(folderBackgroundColor?[0] ?? 0)
        let folderBackgroundGreen = Double(folderBackgroundColor?[1] ?? 0)
        let folderBackgroundBlue = Double(folderBackgroundColor?[2] ?? 0)
        
        let formData = FolderFormData(
            formType: FormType.Folder,
            isAdding: isAdding,
            folderName: newFolderName,
            textRed: textRed,
            textGreen: textGreen,
            textBlue: textBlue,
            folderBackgroundRed: folderBackgroundRed,
            folderBackgroundGreen: folderBackgroundGreen,
            folderBackgroundBlue: folderBackgroundBlue,
            audioURL: audioURL,
            hasAudioChanged: hasAudioChanged
        )
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(formData)
            return data
        }
        catch {
            return nil
        }
    }
    
    init(isPresented: Binding<Bool>) {
        let savedFormState = getSavedFolderState(as: FolderFormData.self, formType: FormType.Folder)
        if let savedFormState {
            self._isPresented = isPresented
            
            _isAdding = State(initialValue: savedFormState.isAdding)
            _audioURL = State(initialValue: savedFormState.audioURL) // EDTODO - verify if this remains correct after audio file handling is done
            _hasAudioChanged = State(initialValue: savedFormState.hasAudioChanged)
            
            _newFolderName = State(initialValue: savedFormState.folderName)
            _newTextColour = State(initialValue: Color(
                red: savedFormState.textRed,
                green: savedFormState.textGreen,
                blue: savedFormState.textBlue)
            )
            _newFolderBackground = State(initialValue: Color(
                red: savedFormState.folderBackgroundRed,
                green: savedFormState.folderBackgroundGreen,
                blue: savedFormState.folderBackgroundBlue)
            )
            return
        }
        
        self._isPresented = isPresented
        let folder = appState.folderBeingEdited
        _isAdding = State(initialValue: folder == nil)
        _newFolderName = State(initialValue: folder?.folderName ?? "")
        
        if let folder = folder {
            _newTextColour = State(
                initialValue: Color(
                    red: folder.textRed,
                    green: folder.textGreen,
                    blue: folder.textBlue
                )
            )
            _newFolderBackground = State(
                initialValue: Color(
                    red: folder.bgRed,
                    green: folder.bgGreen,
                    blue: folder.bgBlue
                )
            )
            intialiseFolderFileURL()
        } else {
            _newTextColour = State(initialValue: .white)
            _newFolderBackground = State(initialValue: .placeholderBackground)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            CloseButton(close: resetState)

            VStack {
                FormButtonName(
                    name: $newFolderName,
                    textColour: newTextColour,
                    backgroundColour: newFolderBackground
                )
                .frame(maxWidth: screenWidth * 0.39)
                .padding(.bottom, 10)
                
                FormColourPicker("Text Colour", colour: $newTextColour)
                    .frame(width: screenWidth * 0.45)
                
                FormColourPicker("Background Colour", colour: $newFolderBackground)
                    .frame(width: screenWidth * 0.45)
                
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
            .frame(
                width: screenWidth,
                height: screenHeight * 0.95
            )
            .audioTooLongAlert(isPresented: $audioTooLong)
            .recordingDeniedAlert(
                isPresented: $recorder.recorderDenied,
                formData: getFormData()
            )
        }
        .onDisappear {
            if recorder.status == RecorderStatus.recording {
                recorder.stopRecording()
            }
            clearTemporaryDirectory()
        }
    }
}
