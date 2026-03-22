import SwiftUI
import CoreData

let getFolders: NSFetchRequest = {
    let request = Folder.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.folderName, ascending: true)]
    return request
}()

struct AddFolderButton: View {
    @State private var newFolderName: String = ""
    @FetchRequest(fetchRequest: getFolders) private var folders: FetchedResults<Folder>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    func addFolder () {
        withAnimation {
            let newItem = Folder(context: viewContext)
            newItem.folderName = newFolderName

            do {
                try viewContext.save()
                newFolderName = ""
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        TextField("Folder Name", text: $newFolderName)
        
        Button(action: addFolder) {
            Text("Create Folder")
        }

        List {
            ForEach(folders) { folder in
                Text(folder.folderName ?? "Timers").foregroundColor(.blue)
            }
        }.background(Color.yellow)
    }
}
