import AVFoundation
import SwiftUI

private let notificationDelegate = NotificationDelegate()

@main
struct TeaTimeApp: App {
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
            logAudioError(error, context: "configuringAudioSession")
        }
        
        UNUserNotificationCenter.current().delegate = notificationDelegate
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, error in
            if let error = error {
                logPermissionError(error, context: "requestingNotificationPermission")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            AppContent().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
