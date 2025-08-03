import Foundation
import CoreData

class TaskStorage {
    
    // MARK: - Properties
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Fetch Tasks
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)]
        
        do {
            let tasks = try coreDataManager.viewContext.fetch(request)
            print("Загружено \(tasks.count) задач из CoreData")
            for (index, task) in tasks.enumerated() {
                print("CoreData задача \(index + 1): ID=\(task.id ?? "nil"), Title='\(task.title ?? "nil")', Completed=\(task.isCompleted)")
            }
            return tasks
        } catch {
            print("Ошибка загрузки задач: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Save Tasks
    func saveTask(_ taskModel: TaskModel) {
        print("Сохраняю задачу: ID=\(taskModel.id), Title='\(taskModel.title)', Completed=\(taskModel.isCompleted)")
        
        // Проверяем, что ID и title не пустые
        guard !taskModel.id.isEmpty else {
            print("Ошибка: ID задачи пустой")
            return
        }
        
        guard !taskModel.title.isEmpty else {
            print("Ошибка: Title задачи пустой")
            return
        }
        
        // Проверяем, не существует ли уже задача с таким ID
        if taskExists(withId: taskModel.id) {
            print("Задача с ID \(taskModel.id) уже существует, пропускаю сохранение")
            return
        }
        
        let context = coreDataManager.viewContext
        let task = Task(context: context)
        
        task.id = taskModel.id
        task.title = taskModel.title
        task.taskDescription = taskModel.taskDescription
        task.isCompleted = taskModel.isCompleted
        task.createdDate = taskModel.createdDate
        
        do {
            try context.save()
            print("Задача успешно сохранена в CoreData")
        } catch {
            print("Ошибка сохранения задачи: \(error.localizedDescription)")
        }
    }
    
    func saveTasks(_ taskModels: [TaskModel]) {
        print("Массовое сохранение \(taskModels.count) задач")
        
        let context = coreDataManager.viewContext
        
        for taskModel in taskModels {
            // Проверяем, что ID и title не пустые
            guard !taskModel.id.isEmpty else {
                print("Пропускаю задачу с пустым ID")
                continue
            }
            
            guard !taskModel.title.isEmpty else {
                print("Пропускаю задачу с пустым title")
                continue
            }
            
            // Проверяем, не существует ли уже задача с таким ID
            if taskExists(withId: taskModel.id) {
                print("Задача с ID \(taskModel.id) уже существует, пропускаю")
                continue
            }
            
            let task = Task(context: context)
            task.id = taskModel.id
            task.title = taskModel.title
            task.taskDescription = taskModel.taskDescription
            task.isCompleted = taskModel.isCompleted
            task.createdDate = taskModel.createdDate
        }
        
        do {
            try context.save()
            print("Массовое сохранение завершено успешно")
        } catch {
            print("Ошибка массового сохранения: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Tasks
    func updateTask(_ task: Task) {
        do {
            try coreDataManager.viewContext.save()
            print("Задача успешно обновлена")
        } catch {
            print("Ошибка обновления задачи: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete Tasks
    func deleteTask(_ task: Task) {
        coreDataManager.viewContext.delete(task)
        
        do {
            try coreDataManager.viewContext.save()
            print("Задача успешно удалена")
        } catch {
            print("Ошибка удаления задачи: \(error.localizedDescription)")
        }
    }
    
    func clearAllTasks() {
        let request: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try coreDataManager.viewContext.execute(deleteRequest)
            try coreDataManager.viewContext.save()
            print("Все задачи успешно удалены")
        } catch {
            print("Ошибка очистки задач: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Toggle Completion
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        
        do {
            try coreDataManager.viewContext.save()
            print("Статус задачи переключен на: \(task.isCompleted)")
        } catch {
            print("Ошибка переключения статуса: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Search Tasks
    func searchTasks(query: String) -> [Task] {
        print("Поиск задач с запросом: '\(query)'")
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR taskDescription CONTAINS[cd] %@", query, query)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.createdDate, ascending: false)]
        
        do {
            let tasks = try coreDataManager.viewContext.fetch(request)
            print("Найдено \(tasks.count) задач:")
            for (index, task) in tasks.enumerated() {
                print("  \(index + 1). ID=\(task.id ?? "nil"), Title='\(task.title ?? "nil")', Completed=\(task.isCompleted)")
            }
            return tasks
        } catch {
            print("Ошибка поиска задач: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Helper Methods
    private func taskExists(withId id: String) -> Bool {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        do {
            let count = try coreDataManager.viewContext.count(for: request)
            return count > 0
        } catch {
            print("Ошибка проверки существования задачи: \(error.localizedDescription)")
            return false
        }
    }
} 