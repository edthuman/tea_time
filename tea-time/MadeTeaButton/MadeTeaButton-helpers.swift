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
    
    // notification to show that timer has started
    let startNotif = createNotification(
        title: "Timer started!",
        description: "Tea minus \(length) minutes...",
        playSound: false,
        timeDelay: nil
    )
    
    // notification to show that timer has finished
    let endNotif = createNotification(
        title: "Tea time!",
        description: "🙂‍↕️🙂‍↕️🙂‍↕️",
        playSound: true,
        timeDelay: length
    )

    // send the notifications requests
    let notificationCenter = UNUserNotificationCenter.current()
    do {
        try await notificationCenter.add(startNotif)
        try await notificationCenter.add(endNotif)
    } catch {
        printWithNewlineAbove(input: "Error adding notification: \(error)")
    }
}

func createNotification(title: String, description: String, playSound: Bool, timeDelay: Double?) -> UNNotificationRequest {
    let uuid = UUID().uuidString

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = description
    
    if (playSound) {
        // add default sound to notification config
        let soundName = UNNotificationSoundName(rawValue: "_mary.wav")
        content.sound = UNNotificationSound(named: soundName)
    }
    
    if (timeDelay != nil) {
        // send notification to be sent after timer length passes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeDelay!, repeats: false)
        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)
        return request
    }
    
    // send notification immediately
    let request = UNNotificationRequest(identifier: uuid, content: content, trigger: nil)
    return request
}
