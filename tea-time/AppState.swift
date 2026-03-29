import SwiftUI

class AppState: ObservableObject {
    @Published var page: String = ""
    @Published var folder: String = ""
    @Published var isEditingFolders: Bool = false
    @Published var folderBeingEdited: Folder? = nil

    func setPage(selectedPage: String) {
        page = selectedPage
    }
    
    func setFolder(selectedFolder: String) {
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
