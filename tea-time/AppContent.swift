import SwiftUI

@MainActor
struct AppContent: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var state = appState
    
    var body: some View {
        Group {
            if let folderId = state.folderId {
                Timers(folderId: folderId)
            } else {
                Folders()
            }
        }
        .onAppear {
            if let savedState = getCurrentSavedState(context: viewContext) {
                state.folderId = savedState.folderId
                state.isEditingTimers = savedState.isEditingTimers
                state.folderBeingEdited = savedState.folderBeingEdited
                state.isEditingFolders = savedState.isEditingFolders
                state.timerBeingEdited = savedState.timerBeingEdited
            }
        }
    }
}
