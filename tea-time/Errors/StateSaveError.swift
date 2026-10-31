enum StateSave {
    case appState
    case audioState
    case formState
}

enum StateError: Error {
    case saveFailed(operation: StateSave, underlyingError: Error)
    
    var operation: StateSave {
        switch self {
            case .saveFailed(operation: let operation, underlyingError: _): return operation
        }
    }
    
    var underlyingError: Error {
        switch self {
            case .saveFailed(operation: _, let underlyingError): return underlyingError
        }
    }
}
