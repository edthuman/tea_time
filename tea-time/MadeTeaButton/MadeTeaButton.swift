import SwiftUI

let reallyMilkyTea = Color(red: 204/255, green: 172/255, blue: 133/255)
let milkyTea = Color(red: 184/255, green: 145/255, blue:109/255)
let blackTea = Color(red: 69/255, green: 42/255, blue: 22/255)

struct MadeTeaButton: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    await beginTimer(length: 5) // todo - fix to be 15 * 60
                }
            } label: {
                Text("Made tea! (15 mins)").foregroundStyle(blackTea)
                
            }
            .padding(20)
            .background(milkyTea, in: RoundedRectangle(cornerRadius: 12))
            
            Button {
                Task {
                    await beginTimer(length: 10) // todo - fix time to be 20 * 60
                }
            } label: {
                Text("Made tea! (20 mins)").foregroundStyle(reallyMilkyTea)
            }.padding(20)
            .background(blackTea, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}
