import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if (state.folder.count == 0) {
            Folders()
        } else {
            VStack {
                BackButton()
                Timers()
            }
        }
    }
}
