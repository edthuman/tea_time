import SwiftUI

class AppState: ObservableObject {
    @Published var page: String = ""
    @Published var folder: String = ""
    @Published var isEditingFolders: Bool = false

    func setPage(selectedPage: String) {
        page = selectedPage
    }
    
    func setFolder(selectedFolder: String) {
        folder = selectedFolder
    }
    
    func setIsEditingFolders(isEditing: Bool) {
        isEditingFolders = isEditing
    }
}

var appState = AppState()
