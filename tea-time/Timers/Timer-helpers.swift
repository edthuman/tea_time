import UserNotifications

/// adds clean print statements to the console during testing
func printWithNewlineAbove(input: Any) {
    print("\n")
    print(input)
}

/// starts a timer of the given length of seconds
/// use of seconds means incomplete - e.g. half/quarter minutes are easier to generate
func beginTimer(length: Double, timer: Timer) async {
    var timeToShow: String
    if (length == 1.0) {
        timeToShow = "1 second"
    } else if (length < 60) {
        timeToShow = "\(Int(length)) seconds"
    } else {
        let minutes = Int(length / 60)
        timeToShow = minutes == 1 ? "1 minute" : "\(minutes) minutes"
    }
    
    // notification to show that timer has started
    let startNotif = createNotification(
        title: "Timer started!",
        description: "Tea minus \(timeToShow)...",
        playSound: false,
        timeDelay: nil,
        timer: timer
    )
    
    // notification to show that timer has finished
    let endNotif = createNotification(
        title: "Tea time!",
        description: "🙂‍↕️🙂‍↕️🙂‍↕️",
        playSound: true,
        timeDelay: length,
        timer: timer
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

func createNotification(title: String, description: String, playSound: Bool, timeDelay: Double?, timer: Timer) -> UNNotificationRequest {
    let uuid = UUID().uuidString

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = description
    
    if (playSound && timer.folder?.folderName == "Mary") {
        // add default sound to notification config
        let soundName = UNNotificationSoundName(rawValue: "_mary.wav")
        content.sound = UNNotificationSound(named: soundName)
    } else if (playSound && timer.folder?.folderName == "Ed") {
        let soundName = UNNotificationSoundName(rawValue: "_ed.wav")
        content.sound = UNNotificationSound(named: soundName)
    } else if (playSound) {
        let soundName = UNNotificationSoundName(
            rawValue: timer.objectID.uriRepresentation().lastPathComponent
        )
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

func getFileNameForTimer (timer: Timer) -> String {
    return timer.objectID.uriRepresentation().lastPathComponent
}

func getSoundsDirectoryURL() throws -> URL {
    let fileManager = FileManager.default
    
    let soundsDirectoryURL = fileManager.urls(
        for: .libraryDirectory,
        in: .userDomainMask
    )
    .first!
    .appendingPathComponent("Sounds")
    
    try fileManager.createDirectory(
        at: soundsDirectoryURL,
        withIntermediateDirectories: true,
        attributes: nil
    )
    return soundsDirectoryURL
}

func getSoundFileURL(fileName: String) throws -> URL {
    let soundsDirectoryURL = try getSoundsDirectoryURL()

    let soundFileURL = soundsDirectoryURL
        .appendingPathComponent(fileName)
    return soundFileURL
}
