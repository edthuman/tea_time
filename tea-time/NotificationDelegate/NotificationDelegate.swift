import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    // called when a notification is delivered whilst the app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    // todo - verify when this is triggered - supposed to be when a notification sent whilst app is in the background is clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        printWithNewlineAbove(input: "User tapped the notification!")
        completionHandler()
    }
}
