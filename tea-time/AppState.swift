import SwiftUI
import CoreData

class AppState: ObservableObject {
    @Published var folderId: NSManagedObjectID? = nil
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil
    @Published var isEditingTimers: Bool = false
    @Published var timerBeingEdited: Timer? = nil
    
    @Environment(\.managedObjectContext) private var viewContext
    
    init() {
        if let currentState = getCurrentSavedState(context: viewContext) {
            folderId = currentState.folderId
            isEditingTimers = currentState.isEditingTimers
            folderBeingEdited = currentState.folderBeingEdited
            isEditingFolders = currentState.isEditingFolders
            timerBeingEdited = currentState.timerBeingEdited
        }
    }
    
    func setFolder(_ selectedFolder: NSManagedObjectID?) {
        folderId = selectedFolder
    }
    
    func setIsEditingFolders(_ isEditing: Bool) {
        isEditingFolders = isEditing
    }
    
    func setFolderBeingEdited(_ folder: Folder?) {
        folderBeingEdited = folder
    }
    
    func backToHome() {
        setFolder(nil)
        setIsEditingFolders(false)
        setFolderBeingEdited(nil)
        setIsEditingTimers(false)
        setTimerBeingEdited(nil)
    }
    
    func setIsEditingTimers(_ isEditing: Bool) {
        isEditingTimers = isEditing
    }
    
    func setTimerBeingEdited(_ timer: Timer?) {
        timerBeingEdited = timer
    }
    
    func saveCurrentState() {
        saveState(
            folderId: folderId,
            isEditingFolders: isEditingFolders,
            folderBeingEdited: folderBeingEdited,
            isEditingTimers: isEditingTimers,
            timerBeingEdited: timerBeingEdited
        )
    }
}

var appState = AppState()
