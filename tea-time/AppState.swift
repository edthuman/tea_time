import SwiftUI
import CoreData

class AppState: ObservableObject {
    @Published var folderId: NSManagedObjectID? = nil
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil
    @Published var timer: String? = nil
    @Published var timerBeingEdited: Timer? = nil
    
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
    }
    
    func setTimer(_ selectedTimer: String?) {
        timer = selectedTimer
    }
    
    func setTimerBeingEdited(_ timer: Timer?) {
        timerBeingEdited = timer
    }
}

var appState = AppState()
