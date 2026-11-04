import OSLog

private let permissionLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Permissions")

func logPermissionError(_ error: Error, context: String) {
    let nsError = error as NSError
    permissionLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let stateManagementLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "StateManagement")

func logStateError(_ error: Error, context: String) {
    let nsError = error as NSError
    stateManagementLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let temporaryFileLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "TemporaryFiles")

func logTemporaryFileError(_ error: Error, context: String) {
    let nsError = error as NSError
    temporaryFileLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let audioLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AudioFiles")

func logAudioError(_ error: Error, context: String) {
    let nsError = error as NSError
    audioLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let folderLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Folders")

func logFolderError(_ error: Error, context: String) {
    let nsError = error as NSError
    folderLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let timerLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Timers")

func logTimerError(_ error: Error, context: String) {
    let nsError = error as NSError
    timerLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let notificationLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Notifications")

func logNotificationError(_ error: Error, context: String) {
    let nsError = error as NSError
    notificationLogger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}
