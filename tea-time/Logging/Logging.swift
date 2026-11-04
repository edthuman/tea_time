import OSLog

private func logError(_ error: Error, logger: Logger, context: String) {
    let nsError = error as NSError
    logger.error("""
    Context: \(context, privacy: .public)
    Error Domain: \(nsError.domain, privacy: .public)
    Error Code: \(nsError.code, privacy: .public)
    Localised Error Description: \(nsError.localizedDescription, privacy: .private)
    """)
}

private let coreDataLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "CoreData")

func logCoreDataError(_ error: Error, context: String) {
    logError(error, logger: coreDataLogger, context: context)
}

private let permissionLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Permissions")

func logPermissionError(_ error: Error, context: String) {
    logError(error, logger: permissionLogger, context: context)
}

private let stateManagementLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "StateManagement")

func logStateError(_ error: Error, context: String) {
    logError(error, logger: stateManagementLogger, context: context)
}

private let temporaryFileLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "TemporaryFiles")

func logTemporaryFileError(_ error: Error, context: String) {
    logError(error, logger: temporaryFileLogger, context: context)
}

private let audioLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "AudioFiles")

func logAudioError(_ error: Error, context: String) {
    logError(error, logger: audioLogger, context: context)
}

private let folderLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Folders")

func logFolderError(_ error: Error, context: String) {
    logError(error, logger: folderLogger, context: context)
}

private let timerLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Timers")

func logTimerError(_ error: Error, context: String) {
    logError(error, logger: timerLogger, context: context)
}

private let notificationLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "Notifications")

func logNotificationError(_ error: Error, context: String) {
    logError(error, logger: notificationLogger, context: context)
}
