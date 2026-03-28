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
                ForEach(folders) { folder in
                    if (state.isEditingFolders) {
                        HStack {
                            getFolderButton(folder: folder)
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.blue)
                                .padding(.horizontal, 10)
                            
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
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
        }
    }
}
