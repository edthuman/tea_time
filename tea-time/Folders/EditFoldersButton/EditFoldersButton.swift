import SwiftUI

struct EditFoldersButton: View {
    var body: some View {
        ZStack (alignment: .trailing){
            Button {
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }.padding(.trailing, 20)
    }
}
