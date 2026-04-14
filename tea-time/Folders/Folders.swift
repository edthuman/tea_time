import SwiftUI
import CoreData

func setFolder(folder: String?) {
    appState.setFolder(folder)
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
        if (!folders.isEmpty) {
            EditFoldersButton()
        }

        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            VStack {
                Group {
                    if (folders.isEmpty) {
                        EmptyFoldersList()
                    } else {
                        ViewThatFits {
                            FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                            
                            ScrollView {
                                FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                            }
                        }
                    }
                }
                .frame(height: screenHeight * 0.94)
                .padding(.bottom, 10)
                
                AddFolderButton()
            }
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showEditFolderForm) {
            EditFolderForm(isPresented: $showEditFolderForm)
        }
        .alert(isPresented: $showDelete) {
            let folder = state.folderBeingEdited
            
            func hideAlert() {
                showDelete = false
            }
            
            func deleteFolder() {
                if let folder = folder {
                    viewContext.delete(folder)
                    do {
                        try viewContext.save()
                    } catch {
                        // EDTODO - Replace this implementation with code to handle the error appropriately.
                        // fatalError terminates the app and creates a crash log
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
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
