import SwiftUI

class AppState: ObservableObject {
    @Published var folder: String? = nil
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil
    
    func setFolder(selectedFolder: String?) {
        folder = selectedFolder
    }
    
    func setIsEditingFolders(_ isEditing: Bool) {
        isEditingFolders = isEditing
    }
    
    func setFolderBeingEdited(_ folder: Folder?) {
        folderBeingEdited = folder
    }
}

var appState = AppState()
