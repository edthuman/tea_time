import SwiftUI

let reallyMilkyTea = Color(red: 176/255, green: 155/255, blue: 137/255)
let milkyTea = Color(red: 184/255, green: 145/255, blue:109/255)
let blackTea = Color(red: 69/255, green: 42/255, blue: 22/255)
let homeButtonColor: Color = Color(red: 69/255, green: 42/255, blue: 22/255)

func backHome() {
    appState.setFolder(selectedFolder: "")
}

struct BackButton: View {
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
                Task {
                    backHome()
                }
            } label: {
                Text("🏡 Home")
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.leading, 20)
    }
}

struct MadeTeaButtons: View {
    var body: some View {
        VStack (spacing: 20) {
            Button {
                Task {
                    await beginTimer(length: 15 * 60)
                }
            } label: {
                Text("Made tea! (15 mins)").foregroundStyle(blackTea)
                
            }
            .padding(20)
            .background(milkyTea, in: RoundedRectangle(cornerRadius: 12))
            
            Button {
                Task {
                    await beginTimer(length: 20 * 60)
                }
            } label: {
                Text("Made tea! (20 mins)").foregroundStyle(reallyMilkyTea)
            }.padding(20)
            .background(blackTea, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, 50)
        .frame(height: 730)
    }
}
