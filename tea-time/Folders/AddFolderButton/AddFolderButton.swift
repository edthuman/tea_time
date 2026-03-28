import SwiftUI
import CoreData

struct AddFolderButton: View {
    @State private var isAdding: Bool = false
    
    var body: some View {
        Button {
            isAdding.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.black)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
                .contentShape(Circle())
        }
        .sheet(isPresented: $isAdding) {
            EditFolderForm(isNew: true)
        }
    }
}
