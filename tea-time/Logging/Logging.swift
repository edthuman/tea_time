import OSLog

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
