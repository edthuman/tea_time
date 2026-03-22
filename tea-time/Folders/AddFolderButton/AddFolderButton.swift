import SwiftUI
import CoreData

struct AddFolderButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newFolderName: String = ""

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
    }
}
