import SwiftUI
import CoreData

struct EditFolderForm: View {
    @ObservedObject var state = appState
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isPresented: Bool
    
    @State private var isAdding: Bool
    @State private var newFolderName: String
    @State private var newTextColour: Color
    @State private var newFolderBackground: Color
    
    private func resetState() {
        newFolderName = ""
        newTextColour = .white
        newFolderBackground = .placeholderBackground
        isAdding.toggle()
        appState.setFolderBeingEdited(nil)
        isPresented = false
    }
    
    private func saveChanges () {
        withAnimation {
            let folder: Folder? = appState.folderBeingEdited
  
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
    
    private func addFolder () {
        withAnimation {
            let newItem = Folder(context: viewContext)
            newItem.folderName = newFolderName
            
            let textColor = UIColor(newTextColour).cgColor.components
            newItem.textRed = Double(textColor?[0] ?? 0)
            newItem.textGreen = Double(textColor?[1] ?? 0)
            newItem.textBlue = Double(textColor?[2] ?? 0)
            
            let bgColor = UIColor(newFolderBackground).cgColor.components
            newItem.bgRed = Double(bgColor?[0] ?? 0)
            newItem.bgGreen = Double(bgColor?[1] ?? 0)
            newItem.bgBlue = Double(bgColor?[2] ?? 0)
            
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
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
        let folder = appState.folderBeingEdited
        _isAdding = State(initialValue: folder == nil)
        _newFolderName = State(initialValue: folder?.folderName ?? "")
        
        if folder != nil {
            _newTextColour = State(initialValue: Color(red: folder!.textRed, green: folder!.textGreen, blue: folder!.textBlue))
            _newFolderBackground = State(initialValue: Color(red: folder!.bgRed, green: folder!.bgGreen, blue: folder!.bgBlue))
        } else {
            _newTextColour = State(initialValue: .white)
            _newFolderBackground = State(initialValue: .placeholderBackground)
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
                TextField("Name", text: $newFolderName)
                    .frame(maxWidth: screenWidth * 0.3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(newTextColour)
                    .fontWeight(.bold)
                    .padding(20)
                    .background(
                        newFolderBackground,
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                
                ColorPicker("Text Colour", selection: $newTextColour)
                    .frame(width: screenWidth * 0.45)
                    .padding(.top, 5)
                    .padding(.vertical, 10)
                
                ColorPicker("Background Colour", selection: $newFolderBackground)
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
