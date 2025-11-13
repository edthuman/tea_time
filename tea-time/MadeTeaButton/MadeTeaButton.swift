import SwiftUI

struct MadeTeaButton: View {
    var body: some View {
        VStack {
            Button {
                Task {
                    /*
                     10 second delay added
                     - For simulator - only shows if app is in the background
                     - On actual phone - only shows the notifcations when the app is rebuilt
                     */
                    await beginTimer(length: 10)
                }
            } label: {
                Text("Made tea!")
            }
        }
    }
}
