import SwiftUI
import CoreData

struct AddTimerButton: View {
    @ObservedObject var state = appState
    @State private var isAdding: Bool = false
    
    var body: some View {
        Button {
            state.setTimerBeingEdited(nil)
            isAdding.toggle()
        } label: {
            AddIcon()
        }
        .sheet(isPresented: $isAdding) {
            EditTimerForm(isPresented: $isAdding)
        }
    }
}
