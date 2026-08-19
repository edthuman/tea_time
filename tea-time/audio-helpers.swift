import CoreData
import SwiftUI

private let fileManager = FileManager.default

func getFileName(_ item: NSManagedObject) -> String {
    return item.objectID.uriRepresentation().lastPathComponent
}

func getSoundsDirectoryURL() throws -> URL {
    let librayURLs = fileManager.urls(
        for: .libraryDirectory,
        in: .userDomainMask
    )

    guard let libraryURL = librayURLs.first else {
        throw FileDirectoryErrors.libraryDirectoryNotFound
    }
    let soundsDirectoryURL: URL = libraryURL.appendingPathComponent("Sounds")

    try fileManager.createDirectory(
        at: soundsDirectoryURL,
        withIntermediateDirectories: true,
        attributes: nil
    )
    return soundsDirectoryURL
}

/// Returns the URL for a sound saved to a given object, or nil if none can be found
func getItemSoundURL(_ item: NSManagedObject?) -> URL? {
    guard let item = item else {
        return nil
    }
    
    do {
        let fileName = getFileName(item)
        let url: URL = try getSoundFileURL(fileName: fileName)
        
        if fileManager.fileExists(atPath: url.path) {
            return url
        }
    }
    catch {
        printWithNewlineAbove(input: "Error initialising sound file URL")
    }
    return nil
}

/// Returns the full URL for a given sound file from its name
func getSoundFileURL(fileName: String) throws -> URL {
    let soundsDirectoryURL = try getSoundsDirectoryURL()

    let soundFileURL = soundsDirectoryURL
        .appendingPathComponent(fileName)
    return soundFileURL
}

/// Recordings are saved to the temporary directory - getting saved to the library directory if the user saves the item
func getRecordingURL() -> URL { fileManager.temporaryDirectory.appendingPathComponent("latest_recording.caf")
}

func deleteSoundFile(fileName: String) throws {
    let soundFileURL = try getSoundFileURL(fileName: fileName)

    if fileManager.fileExists(atPath: soundFileURL.path()) {
        try fileManager.removeItem(at: soundFileURL)
    }
}

func saveNotificationSound(fileURL: URL?, fileName: String, hasAudioChanged: Bool) {
    if hasAudioChanged == false {
        // Prevent re-saving of audio from bookmark when the file is not changed
        return
    }
    
    do {
        let soundFileURL: URL = try getSoundFileURL(fileName: fileName)
            
        guard let url = fileURL else {
            // Sound removed from timer
            try deleteSoundFile(fileName: fileName)
            return
        }
        
        if fileManager.fileExists(atPath: soundFileURL.path) {
            _ = try fileManager.replaceItemAt(
                soundFileURL,
                withItemAt: url
            )
        } else {
            try fileManager.copyItem(
                at: url,
                to: soundFileURL,
            )
        }
    }
    catch {
        printWithNewlineAbove(input: "Failed to create audio file:\n \(error)\n")
    }
}

func checkFileExists(fileName: String) -> Bool {
    do {
        let soundFileURL = try getSoundFileURL(fileName: fileName)
        return fileManager.fileExists(atPath: soundFileURL.path)
    }
    catch {
        // Add proper error handling
        let nsError = error as NSError
        printWithNewlineAbove(input: "Error occurred whilst checking if sound file exists \(nsError), \(nsError.userInfo)")
        return false
    }
}

func clearTemporaryDirectory() {
    var temporaryFiles: [URL] = []
    do {
        temporaryFiles = try fileManager.contentsOfDirectory(at: fileManager.temporaryDirectory, includingPropertiesForKeys: nil)
    }
    catch {
        printWithNewlineAbove(input: "Failed to fetch temporary files: \(error)")
    }
    
    for file in temporaryFiles {
        do {
            try fileManager.removeItem(at: file)
        }
        catch {
            printWithNewlineAbove(input: "Failed to remove temporary file \(file): \(error)")
        }
    }
}
