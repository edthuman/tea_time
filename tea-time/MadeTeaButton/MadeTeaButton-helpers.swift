import UserNotifications

/// adds clean print statements to the console during testing
func printWithNewlineAbove(input: Any) {
    print("\n")
    print(input)
}

/// starts a timer of the given length of seconds
/// use of seconds means incomplete - e.g. half/quarter minutes are easier to generate
func beginTimer(length: Double) async {
    printWithNewlineAbove(input: "Creating a timer for \(length) seconds...")

    let request = createNotification(timeDelay: length)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllPendingNotificationRequests()
    
    do {
        try await notificationCenter.add(request)
        printWithNewlineAbove(input: "Notification added!")
    } catch {
        printWithNewlineAbove(input: "Error adding notification: \(error)")
    }
    
    // print requests that are pending in the notification center
    let requests = await notificationCenter.pendingNotificationRequests()
    printWithNewlineAbove(input: requests)
}

func createNotification(timeDelay: Double) -> UNNotificationRequest {
    let uuid = UUID().uuidString

    let content = UNMutableNotificationContent()
    content.title = "Tea Alert"
    content.body = "15 minutes begins now..."
    
    let soundName = UNNotificationSoundName(rawValue: "_mary.wav")
    content.sound = UNNotificationSound(named: soundName)
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeDelay, repeats: false)
    let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
    return request
}
