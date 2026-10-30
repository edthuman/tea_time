enum StateSave {
    case appState
    case audioState
    case formState
}

enum StateError: Error {
    case saveFailed(operation: StateSave, underlyingError: Error)
}
