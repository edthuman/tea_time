import SwiftUI

class AppState: ObservableObject {
    @Published var folder: String? = nil
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil
    @Published var timer: String? = nil
    
    func setFolder(_ selectedFolder: String?) {
        folder = selectedFolder
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
}

var appState = AppState()
