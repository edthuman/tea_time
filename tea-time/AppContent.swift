import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if let folderId = state.folderId {
            VStack {
                BackButton()
                Timers(folderId: folderId)
            }
        } else {
            Folders()
        }
    }
}
