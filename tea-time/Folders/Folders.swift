import SwiftUI
import CoreData

let black = Color(red: 0/255, green: 0/255, blue: 0/255)
let white = Color(red: 255/255, green: 255/255, blue: 255/255)
let fbiPurple = Color(red: 162/255, green: 132/255, blue: 192/255)
let fbiBlue = Color(red: 96/255, green: 116/255, blue: 167/255)

func setPage(page: String) {
    appState.setPage(selectedPage: page)
}

func setFolder(folder: String) {
    appState.setFolder(selectedFolder: folder)
}

struct Folders: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Folder.folderName, ascending: true)],
        animation: .default
    )
    private var folders: FetchedResults<Folder>

    private func colorForFolder(_ name: String) -> Color {
        switch name {
        case "Mary":
            return fbiPurple
        case "Ed":
            return fbiBlue
        default:
            return black
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            VStack (spacing: 20) {
                ForEach(folders) { folder in
                    let folderName: String = folder.folderName ?? ""
                    Button {
                        setFolder(folder: folderName)
                    } label: {
                        Text(folderName).foregroundStyle(white).fontWeight(.bold)
                            .frame(maxWidth: screenWidth * 0.3)
                    }
                    .padding(20)
                    .background(
                        Color(
                            red: folder.red, green: folder.green, blue: folder.blue
                        ),
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                }
                
                AddFolderButton()
            }
            .frame(width: screenWidth)
            .padding(.bottom, 50)
            .frame(height: 730)
        }
    }
}
