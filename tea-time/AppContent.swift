import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if (state.page == "Settings") {
            BackButton()
            Settings()
        } else if (state.folder.count == 0) {
            VStack {
                SettingsButton()
                Folders()
            }
        } else {
            VStack {
                BackButton()
                MadeTeaButtons()
            }
        }
    }
}
