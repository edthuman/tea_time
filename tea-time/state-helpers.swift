import CoreData
import Foundation

private let fileManager = FileManager.default
private let stateFileName = "state.json"
private let formStateFileName = "form-state.json"
let audioStateFileName = "audio-state"

struct AppStateProps {
    var folderId: NSManagedObjectID? = nil
    var isEditingFolders: Bool = false
    var folderBeingEdited: Folder? = nil
    var isEditingTimers: Bool = false
    var timerBeingEdited: Timer? = nil
}

struct StoredAppState: Codable {
    var folderId: URL?
    var isEditingFolders: Bool
    var folderBeingEditedIdUri: URL?
    var isEditingTimers: Bool
    var timerBeingEditedIdUri: URL?
}

protocol HasFormType {
    var formType: FormType { get }
}

enum FormType: String, Codable {
    case Folder
    case Timer
}

func getStateDirectoryURL() throws -> URL {
    let appSupportURLs = fileManager.urls(
        for: .applicationSupportDirectory,
        in: .userDomainMask
    )

    guard let appSupportURL = appSupportURLs.first else {
        throw FileDirectoryErrors.applicationSupportDirectoryNotFound
    }
    let stateDirectoryURL: URL = appSupportURL.appendingPathComponent("State")
    return stateDirectoryURL
}

func createStateDirectory() throws {
    let stateDirectoryURL: URL = try getStateDirectoryURL()
    try fileManager.createDirectory(
        at: stateDirectoryURL,
        withIntermediateDirectories: true,
        attributes: nil
    )
}

func getStateURL(_ fileName: String) throws -> URL {
    let stateDirectoryURL: URL = try getStateDirectoryURL()
    let stateFileURL: URL = stateDirectoryURL.appendingPathComponent(fileName)
    return stateFileURL
}

func saveState(folderId: NSManagedObjectID?, isEditingFolders: Bool, folderBeingEdited: Folder?, isEditingTimers: Bool, timerBeingEdited: Timer? = nil) throws {
    let state: StoredAppState = StoredAppState(
        folderId: folderId?.uriRepresentation() ?? nil,
        isEditingFolders: isEditingFolders,
        folderBeingEditedIdUri: folderBeingEdited?.objectID.uriRepresentation() ?? nil,
        isEditingTimers: isEditingTimers,
        timerBeingEditedIdUri: timerBeingEdited?.objectID.uriRepresentation() ?? nil
    )
    
    let jsonEncoder: JSONEncoder = JSONEncoder()
    
    do {
        let stateFileURL: URL = try getStateURL(stateFileName)
        let stateToSave: Data = try jsonEncoder.encode(state)
        try stateToSave.write(to: stateFileURL)
    }
    catch {
        throw StateError.saveFailed(operation: .appState, underlyingError: error)
    }
}

func getStateFromJSON(context: NSManagedObjectContext, data: Data?) throws -> AppStateProps? {
    guard let data else {
        return nil
    }

    let JSONDecoder: JSONDecoder = JSONDecoder()
    let state: StoredAppState = try JSONDecoder.decode(StoredAppState.self, from: data)
    
    let folderId: NSManagedObjectID? = getObjectIDFromUri(context: context, uri: state.folderId)
    let folderBeingEdited: NSManagedObject? = getObjectFromIDUri(context: context, uri: state.folderBeingEditedIdUri)
    let timerBeingEdited: NSManagedObject? = getObjectFromIDUri(context: context, uri: state.timerBeingEditedIdUri)
    
    return AppStateProps(
        folderId: folderId,
        isEditingFolders: state.isEditingFolders,
        folderBeingEdited: folderBeingEdited as? Folder,
        isEditingTimers: state.isEditingTimers,
        timerBeingEdited: timerBeingEdited as? Timer
    )
}

func getObjectIDFromUri(context: NSManagedObjectContext, uri: URL?) -> NSManagedObjectID? {
    guard let storeCoordinator = context.persistentStoreCoordinator else {
        return nil
    }
    let id: NSManagedObjectID? = uri.flatMap {
        storeCoordinator.managedObjectID(forURIRepresentation: $0)
    }
    return id
}

func getObjectFromIDUri(context: NSManagedObjectContext, uri: URL?) -> NSManagedObject? {
    let objectID = getObjectIDFromUri(context: context, uri: uri)
    guard let objectID else {
        return nil
    }
    do {
        return try context.existingObject(with: objectID)
    }
    catch {
        return nil
    }
}

func getCurrentSavedState(context: NSManagedObjectContext) -> AppStateProps? {
    do {
        let stateFileURL: URL = try getStateURL(stateFileName)
        let stateFile: Data? = try Data(contentsOf: stateFileURL)
        return try getStateFromJSON(context: context, data: stateFile)
    }
    catch {
        let nsError = error as NSError
        printWithNewlineAbove(input: "State file not found \(nsError), \(nsError.userInfo)")
        return nil
    }
}

func saveFormState(formData: Data?) throws {
    guard let formData else {
        return
    }
    do {
        let stateFileURL: URL = try getStateURL(formStateFileName)
        try formData.write(to: stateFileURL)
    }
    catch {
        throw StateError.saveFailed(operation: .formState, underlyingError: error)
    }
}

func getSavedFolderState<T: Codable & HasFormType>(as: T.Type, formType: FormType) -> T? {
    do {
        let stateDirectoryURL: URL = try getStateDirectoryURL()
        let stateFileURL: URL = stateDirectoryURL.appendingPathComponent(formStateFileName)
        let data = try Data(contentsOf: stateFileURL)
        let jsonDecoder: JSONDecoder = JSONDecoder()
        let savedState = try jsonDecoder.decode(T.self, from: data)
        if formType == savedState.formType {
            return savedState
        }
        return nil
    }
    catch {
        return nil
    }
}

func deleteSavedState() {
    do {
        let stateDirectoryURL: URL = try getStateDirectoryURL()
        try fileManager.removeItem(at: stateDirectoryURL)
    }
    catch {
        if error as? FileDirectoryErrors == .applicationSupportDirectoryNotFound {
            return
        }
        
        let cocoaError = error as? CocoaError
        if cocoaError?.code != CocoaError.fileNoSuchFile {
            logStateError(error, context: "deletingAppState")
        }
    }
}

func saveAudioState(audioURL: URL?) throws {
    guard let audioURL else {
        return
    }
    do {
        try saveNotificationSound(
            fileURL: audioURL,
            fileName: audioStateFileName,
            hasAudioChanged: true
        )
    }
    catch {
        throw StateError.saveFailed(operation: .audioState, underlyingError: error)
    }
}
