import SwiftUI

class AppState: ObservableObject {
    @Published var folder: String = ""

    func setFolder(selectedFolder: String) {
     folder = selectedFolder
    }
}

var appState = AppState()
