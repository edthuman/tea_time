import SwiftUI
import CoreData

struct AddFolderButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newFolderName: String = ""
    @State private var isAdding: Bool = false

    func addFolder () {
        withAnimation {
            let newItem = Folder(context: viewContext)
            newItem.folderName = newFolderName

            do {
                try viewContext.save()
                newFolderName = ""
                isAdding.toggle()
            } catch {
                // EDTODO - Replace this implementation with code to handle the error appropriately.
                // fatalError terminates the app and creates a crash log
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    var body: some View {
        Button {
            isAdding.toggle()
        } label: {
            Text("+")
        }
        .sheet(isPresented: $isAdding) {
            TextField("Folder Name", text: $newFolderName)
            
            Button(action: addFolder) {
                Text("Create Folder")
            }
        }
    }
}
