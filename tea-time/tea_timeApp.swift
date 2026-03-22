import SwiftUI

private let notificationDelegate = NotificationDelegate()

@main
struct tea_timeApp: App {
    let persistenceController = PersistenceController.shared
    
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
            AppContent().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
