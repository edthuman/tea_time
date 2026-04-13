import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "core_data_model")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
                /* EDTODO - add better error handling
                    Xcode states that typical reasons for errors include:
                    - The parent directory does not exist, cannot be created, or disallows writing.
                    - The persistent store is not accessible, due to permissions or data protection when the device is locked.
                    - The device is out of space.
                    - The store could not be migrated to the current model version.
                 */
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

