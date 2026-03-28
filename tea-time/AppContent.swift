import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if (state.folder.count == 0) {
            VStack {
                EditFoldersButton()
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
