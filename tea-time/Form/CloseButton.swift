import SwiftUI

struct CloseButton: View {
    let close: () -> Void
    
    var body: some View {
        Button(action: close) {
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 17)
        .padding(.trailing, 17)
    }
}
