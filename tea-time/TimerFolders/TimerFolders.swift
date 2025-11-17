import SwiftUI

let white = Color(red: 255/255, green: 255/255, blue: 255/255)
let fbiPurple = Color(red: 162/255, green: 132/255, blue: 192/255)
let fbiBlue = Color(red: 96/255, green: 116/255, blue: 167/255)

func setFolder(folder: String) {
    appState.setFolder(selectedFolder: folder)
}

struct TimerFolders: View {
    var body: some View {
        VStack (spacing: 20) {
            Button {
                Task {
                    setFolder(folder: "Mary")
                }
            } label: {
                Text("Timer for Mary").foregroundStyle(white).fontWeight(.medium)
                
            }
            .padding(20)
            .background(fbiPurple, in: RoundedRectangle(cornerRadius: 12))
            
            Button {
                Task {
                    setFolder(folder: "Ed")
                }
            } label: {
                Text("Timer for Ed").foregroundStyle(white).fontWeight(.medium)
            }.padding(20)
                .background(fbiBlue, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
