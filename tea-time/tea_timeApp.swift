import AVFoundation
import SwiftUI

private let notificationDelegate = NotificationDelegate()

@main
struct tea_timeApp: App {
    let persistenceController = PersistenceController.shared
    
    init () {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetooth]
            )
        } catch {
            printWithNewlineAbove(
                input: "Failed to configure audio session: \(error)"
            )
        }
        
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
