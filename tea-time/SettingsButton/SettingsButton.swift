import SwiftUI

struct SettingsButton: View {
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
                Task {
                    setPage(page: "Settings")
                }
            } label: {
                Text("⚙️")
                    .foregroundStyle(Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }.padding(.trailing, 20)
    }
}
