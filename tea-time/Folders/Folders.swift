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
        if (!folders.isEmpty) {
            EditFoldersButton()
        }
            
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
      
            VStack {
                ViewThatFits {
                    FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                    
                    ScrollView {
                        FoldersList(showEditFolderForm: $showEditFolderForm, showDelete: $showDelete, folders: folders)
                    }
                }
                .frame(height: screenHeight * 0.94)
                .padding(.bottom, 10)
                
                AddFolderButton()
            }
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
