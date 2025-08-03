import Foundation
import CoreData

// MARK: - TaskDetail Interactor
// Interactor содержит бизнес-логику для работы с деталями задачи

class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    // MARK: - Properties
    var output: TaskDetailInteractorOutputProtocol?
    private let taskStorage = TaskStorage()
    
    // MARK: - TaskDetailInteractorProtocol
    func fetchTask(id: String) {
        output?.loadingStarted()
        
        let tasks = taskStorage.fetchTasks()
        if let task = tasks.first(where: { $0.id == id }) {
            DispatchQueue.main.async { [weak self] in
                self?.output?.loadingFinished()
                // Здесь можно добавить метод для передачи задачи, если нужно
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.output?.loadingFinished()
                self?.output?.errorOccurred("Задача не найдена")
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        output?.loadingStarted()
        
        taskStorage.deleteTask(task)
        
        DispatchQueue.main.async { [weak self] in
            self?.output?.loadingFinished()
            self?.output?.taskDeleted()
        }
    }
} 