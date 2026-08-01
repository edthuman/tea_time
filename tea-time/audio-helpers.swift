import SwiftUI

private let fileManager = FileManager.default

func getFileNameForTimer (timer: Timer) -> String {
    return timer.objectID.uriRepresentation().lastPathComponent
}

func getFileNameForFolder (folder: Folder) -> String {
    return folder.objectID.uriRepresentation().lastPathComponent
}

func getSoundsDirectoryURL() throws -> URL {
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
