import SwiftUI

@MainActor
struct AppContent: View {
    @ObservedObject var state = appState
    
    var body: some View {
        if state.folder == nil {
            Folders()
        } else {
            VStack {
                BackButton()
                Timers()
            }
        }
    }
}
