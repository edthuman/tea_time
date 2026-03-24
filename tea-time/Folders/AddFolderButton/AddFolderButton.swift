import SwiftUI
import CoreData

func hexToDouble(_ hex: String) -> Double {
   return (Double(hex) ?? 0) / 255.0
}

struct AddFolderButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isAdding: Bool = false
    @State private var newFolderName: String = ""
    @State private var newFolderRed: String = ""
    @State private var newFolderGreen: String = ""
    @State private var newFolderBlue: String = ""
    
    private func resetState() {
        newFolderName = ""
        newFolderRed = ""
        newFolderGreen = ""
        newFolderBlue = ""
        isAdding.toggle()
    }
    
    func addFolder () {
        withAnimation {
            let newItem = Folder(context: viewContext)
            newItem.folderName = newFolderName
            newItem.red = hexToDouble(newFolderRed)
            newItem.green = hexToDouble(newFolderGreen)
            newItem.blue = hexToDouble(newFolderBlue)

            do {
                try viewContext.save()
                resetState()
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
            GeometryReader { geometry in
                VStack {
                    TextField("Folder Name", text: $newFolderName)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width * 0.6)

                    TextField("Red", text: $newFolderRed)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width * 0.6)
                    
                    TextField("Green", text: $newFolderGreen)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width * 0.6)
                    
                    TextField("Blue", text: $newFolderBlue)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width * 0.6)
                    
                    Button(action: addFolder) {
                        Text("Create Folder")
                    }
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * 0.95
                )
            }
        }
    }
}
