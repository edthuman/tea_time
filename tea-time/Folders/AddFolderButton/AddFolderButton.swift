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
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
                .contentShape(Circle())
        }
        .sheet(isPresented: $isAdding) {
            EditFolderForm(isPresented: $isAdding)
        }
    }
}
