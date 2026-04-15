import SwiftUI

struct FolderButton: View {
    let folder: Folder
    let screenWidth = UIScreen.main.bounds.width
    
    var folderName: String {
        folder.folderName ?? ""
    }
    
    var body: some View {
         Button {
            setFolder(folderName)
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
}
