import SwiftUI
import CoreData

func hexToDouble(_ hex: String) -> Double {
   return (Double(hex) ?? 0) / 255.0
}

let initialBgColor: Color = Color(red: 1, green: 0.5255, blue: 0.2824)

struct AddFolderButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isAdding: Bool = false
    @State private var newFolderName: String = ""
    @State private var newTextColour: Color = .white
    @State private var newFolderBackground: Color = initialBgColor
    
    private func resetState() {
        newFolderName = ""
        newTextColour = .white
        newFolderBackground = initialBgColor
        isAdding.toggle()
    }
    
    func addFolder () {
        withAnimation {
            let newItem = Folder(context: viewContext)
            newItem.folderName = newFolderName
            
            let textColor = UIColor(newTextColour).cgColor.components
            newItem.textRed = Double(textColor?[0] ?? 0)
            newItem.textGreen = Double(textColor?[1] ?? 0)
            newItem.textBlue = Double(textColor?[2] ?? 0)
            
            let bgColor = UIColor(newFolderBackground).cgColor.components
            newItem.bgRed = Double(bgColor?[0] ?? 0)
            newItem.bgGreen = Double(bgColor?[1] ?? 0)
            newItem.bgBlue = Double(bgColor?[2] ?? 0)

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
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height
                
                VStack {
                    TextField("Folder Name", text: $newFolderName)
                        .frame(maxWidth: screenWidth * 0.3)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(newTextColour)
                        .fontWeight(newFolderName == "" ? .regular : .bold)
                        .padding(20)
                        .background(
                            newFolderBackground,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                    
                    ColorPicker("Text Color", selection: $newTextColour)
                        .frame(width: screenWidth * 0.45)
                        .padding(.top, 5)
                        .padding(.vertical, 10)
                    
                    ColorPicker("Background Color", selection: $newFolderBackground)
                        .frame(width: screenWidth * 0.45)
                        .padding(.vertical, 10)
                    
                    HStack {
                        Button(action: resetState) {
                            Text("Cancel")
                                .foregroundStyle(.red)
                        }
                        .padding(.trailing, 20)
                        
                        Button(action: addFolder) {
                            Text("Confirm")
                        }
                    }
                    .padding(.top, 5)
                }
                .frame(
                    width: screenWidth,
                    height: screenHeight * 0.95
                )
            }
        }
    }
}
