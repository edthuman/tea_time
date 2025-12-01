import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if (state.folder.count == 0) {
            VStack {
                SettingsButton()
                TimerFolders()
            }
        } else if (state.folder == "Settings") {
                BackButton()
                Settings()
        } else {
            VStack {
                BackButton()
                MadeTeaButtons()
            }
        }
    }
}
