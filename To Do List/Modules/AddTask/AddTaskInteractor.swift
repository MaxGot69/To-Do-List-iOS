import Foundation
import CoreData

final class AddTaskInteractor: AddTaskInteractorProtocol {
    
    // MARK: - Properties
    weak var output: AddTaskInteractorOutputProtocol?
    private let taskStorage = TaskStorage()
    
    // MARK: - Create Task
    func createTask(title: String, description: String?) {
        print("Создаю новую задачу: '\(title)'")
        
        // Создаем уникальный ID
        let taskId = UUID().uuidString
        
        // Создаем модель задачи
        let taskModel = TaskModel(
            id: taskId,
            title: title,
            taskDescription: description,
            createdDate: Date(),
            isCompleted: false
        )
        
        // Сохраняем в CoreData
        taskStorage.saveTask(taskModel)
        
        print("Задача успешно создана с ID: \(taskId)")
        
        // Уведомляем об успехе
        DispatchQueue.main.async { [weak self] in
            self?.output?.taskCreated()
        }
    }
} 
