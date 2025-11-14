import SwiftUI

private let notificationDelegate = NotificationDelegate()

@main
struct tea_timeApp: App {
    init () {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if let error = error {
                print("Permission request failed: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(success)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
