import SwiftUI

class AppState: ObservableObject {
    @Published var folder: String? = nil
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil
    
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
}

var appState = AppState()
