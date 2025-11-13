import SwiftUI

struct MadeTeaButton: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    await beginTimer(length: 10)
                }
            } label: {
                Text("Made tea!")
            }
        }
    }
}
