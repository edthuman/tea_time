import SwiftUI

@MainActor
struct ContentView: View {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("Permission request failed: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(success)")
            }
        }
    }
    
    var body: some View {
        MadeTeaButton()
    }
}
    
#Preview {
    ContentView()
}
