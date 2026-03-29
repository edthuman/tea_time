import SwiftUI
import CoreData

func setPage(page: String) {
    appState.setPage(selectedPage: page)
}

func setFolder(folder: String) {
    appState.setFolder(selectedFolder: folder)
}

func getFolderButton(folder: Folder) -> some View {
    let screenWidth = UIScreen.main.bounds.width
    let folderName = folder.folderName ?? ""
    
    return Button {
        setFolder(folder: folderName)
    } label: {
        Text(folderName)
            .foregroundStyle(
                Color(red: folder.textRed, green: folder.textGreen, blue: folder.textBlue))
            .fontWeight(.bold)
            .frame(maxWidth: screenWidth * 0.3)
            .padding(20)
    }
    .background(
        Color(
            red: folder.bgRed, green: folder.bgGreen, blue: folder.bgBlue
        ),
        in: RoundedRectangle(cornerRadius: 12)
    )
}

struct Folders: View {
    @ObservedObject var state = appState
    @State var showEditFolderForm: Bool = false
    @State var showDelete: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.folderName, ascending: true)],
        animation: .default
    )
    private var folders: FetchedResults<Folder>
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            VStack (spacing: 20) {
                ForEach(folders) { (folder: Folder) in
                    if (state.isEditingFolders) {
                        HStack {
                            getFolderButton(folder: folder)

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
                        getFolderButton(folder: folder)
                    }
                }
                
                AddFolderButton()
            }
            .frame(width: screenWidth)
            .padding(.bottom, 50)
            .frame(height: 730)
            .sheet(isPresented: $showEditFolderForm) {
                EditFolderForm(isPresented: $showEditFolderForm)
            }
        }
        .alert(isPresented: $showDelete) {
            let folder = state.folderBeingEdited
            
            
            func hideAlert() {
                showDelete = false
            }
            
            func deleteFolder() {
                if let folder = folder {
                    viewContext.delete(folder)
                }
            }
            
            return Alert(
                title: Text("You are about to delete \(folder?.folderName ?? "this folder")"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: hideAlert
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: deleteFolder
                )
            )
        }
    }
}
