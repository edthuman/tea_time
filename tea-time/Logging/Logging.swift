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
