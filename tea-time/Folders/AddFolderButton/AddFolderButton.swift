import SwiftUI
import CoreData

struct AddFolderButton: View {
    @ObservedObject var state = appState
    @State private var isAdding: Bool = false
    
    var body: some View {
        Button {
            state.setFolderBeingEdited(nil)
            isAdding.toggle()
        } label: {
            AddIcon()
        }
        .sheet(isPresented: $isAdding) {
            EditFolderForm(isPresented: $isAdding)
        }
    }
}
