import CoreData
import Foundation

private let fileManager = FileManager.default

func getStateDirectoryURL() throws -> URL {
    let appSupportURLs = fileManager.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
    )

    guard let appSupportURL = appSupportURLs.first else {
        throw FileDirectoryErrors.applicationSupportDirectoryNotFound
    }
    let stateDirectoryURL: URL = appSupportURL.appendingPathComponent("State")

    try fileManager.createDirectory(
        at: stateDirectoryURL,
        withIntermediateDirectories: true,
        attributes: nil
    )
    return stateDirectoryURL
}

struct StoredAppState: Codable {
    var folderId: URL?
    var isEditingFolders: Bool
    var folderBeingEditedId: URL?
    var isEditingTimers: Bool
    var timerBeingEditedId: URL?
}

func saveState(folderId: NSManagedObjectID?, isEditingFolders: Bool, folderBeingEdited: Folder?, isEditingTimers: Bool, timerBeingEdited: Timer? = nil) {
    let state: StoredAppState = StoredAppState(
        folderId: folderId?.uriRepresentation() ?? nil,
        isEditingFolders: isEditingFolders,
        folderBeingEditedId: folderBeingEdited?.objectID.uriRepresentation() ?? nil,
        isEditingTimers: isEditingTimers,
        timerBeingEditedId: timerBeingEdited?.objectID.uriRepresentation() ?? nil
    )
    
    let jsonEncoder: JSONEncoder = JSONEncoder()
    
    do {
        let stateToSave: Data = try jsonEncoder.encode(state)
        
        let stateDirectoryURL: URL = try getStateDirectoryURL()
        let stateFileURL: URL = stateDirectoryURL.appendingPathComponent("state.json")
        
        try stateToSave.write(to: stateFileURL)
    }
    catch {
        printWithNewlineAbove(input: "Failed to write state file: \(error)")
        // EDTODO - Think about possible better error handling
    }
    
}
