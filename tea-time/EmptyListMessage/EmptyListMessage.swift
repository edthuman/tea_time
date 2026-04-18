import SwiftUI

struct EmptyListMessage: View {
    let message: String
    
    var body: some View {
        VStack {
            Text("\(message)")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.dynamicBlack)
        }
    }
}
