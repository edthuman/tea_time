import SwiftUI
import CoreData

func setFolder(_ folder: NSManagedObjectID) {
    appState.setFolder(folder)
}

struct Folders: View {
    @ObservedObject var state = appState
    @State var showEditFolderForm: Bool = false
    @State var showDelete: Bool = false
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.folderName, ascending: true)],
        animation: .default
    )
    private var folders: FetchedResults<Folder>
    
    init() {
        if getSavedFolderState(as: FolderFormData.self, formType: FormType.Folder) != nil {
            _showEditFolderForm = State(initialValue: true)
        }
    }
    
    var body: some View {
        if (!folders.isEmpty) {
            EditFoldersButton()
            .padding(.top, getCommandBarPadding(verticalSizeClass))
        }

        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            VStack (spacing: 0) {
                Group {
                    if (folders.isEmpty) {
                        EmptyListMessage(message: "No folders")
                    } else {
                        ViewThatFits {
                            FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                            
                            ScrollView {
                                FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                            }
                        }
                    }
                }
                .frame(height: getListHeight(screenHeight))
                .padding(.bottom, 10)
                
                AddFolderButton()
                .padding(.bottom, getAddButtonPadding(screenHeight))
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
                    do {
                        if let timers = folder.timers as? Set<Timer> {
                            for timer in timers {
                                let soundFileName = getFileName(timer)
                                try deleteSoundFile(fileName: soundFileName)
                            }
                        }
                        viewContext.delete(folder)
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
