import CoreData
import Foundation

// MARK: - Core Data Manager
// Базовый менеджер для работы с CoreData
// Обеспечивает доступ к persistent container и context

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "To_Do_List")
        
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data store failed to load: \(error)")
            }
        }
        
        // Автоматически сохраняем изменения из родительского контекста
        viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Save Context
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Background Context
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
} 