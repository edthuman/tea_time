import SwiftUI

struct CloseButton: View {
    let close: () -> Void
    
    var body: some View {
        Button(action: close) {
            Image(systemName: "xmark")
                .foregroundStyle(.gray)
                .padding(.vertical, 17)
                .padding(.horizontal, 17)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
