import SwiftUI

func toggleIsEditingFolders() {
    let isEditingFolders = !appState.isEditingFolders
    appState.setIsEditingFolders(isEditingFolders)
}

struct EditFoldersButton: View {
    @ObservedObject var state = appState
    
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
                toggleIsEditingFolders()
            } label: {
                if (state.isEditingFolders) {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundStyle(.blue)
                } else {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }.padding(.trailing, 20)
    }
}
