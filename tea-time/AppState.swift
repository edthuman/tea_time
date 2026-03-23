import SwiftUI

class AppState: ObservableObject {
    @Published var page: String = ""
    @Published var folder: String = ""

    func setPage(selectedPage: String) {
        page = selectedPage
    }
    
    func setFolder(selectedFolder: String) {
        folder = selectedFolder
    }
}

var appState = AppState()
