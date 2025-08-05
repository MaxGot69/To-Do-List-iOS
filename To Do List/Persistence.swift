

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newTask = Task(context: viewContext)
            newTask.id = UUID().uuidString
            newTask.title = "Sample Task \(i + 1)"
            newTask.taskDescription = "This is a sample task for preview"
            newTask.createdDate = Date()
            newTask.isCompleted = false
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Preview data creation failed: \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "To_Do_List")
        if inMemory {
            if let firstStore = container.persistentStoreDescriptions.first {
                firstStore.url = URL(fileURLWithPath: "/dev/null")
            }
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Core Data store failed to load: \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
