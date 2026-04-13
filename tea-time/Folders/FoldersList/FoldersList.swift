import SwiftUI

struct FoldersList: View {
    @ObservedObject var state = appState
    @Binding var showEditFolderForm: Bool
    @Binding var showDelete: Bool
    
    let folders: FetchedResults<Folder>
    
    var body: some View {
        VStack (spacing: 20) {
            ForEach(folders) { (folder: Folder) in
                if (state.isEditingFolders) {
                    HStack {
                        FolderButton(folder: folder)
                        
                        Button {
                            state.setFolderBeingEdited(folder)
                            showEditFolderForm = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 10)
                        }
                        
                        Button {
                            state.setFolderBeingEdited(folder)
                            showDelete = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                } else {
                    FolderButton(folder: folder)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
