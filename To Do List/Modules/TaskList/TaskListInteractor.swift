import Foundation
import CoreData

final class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Properties
    weak var output: TaskListInteractorOutputProtocol?
    private let taskAPI = TaskAPI()
    private let taskStorage = TaskStorage()
    
    // MARK: - TaskListInteractorProtocol
    func loadTasksFromAPI() {
        // Проверяем, есть ли уже данные в CoreData
        let existingTasks = taskStorage.fetchTasks()
        if !existingTasks.isEmpty {
            output?.tasksLoaded(existingTasks)
            return
        }
        
        taskAPI.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let taskModels):
                    // Сохраняем задачи в CoreData
                    self?.taskStorage.saveTasks(taskModels)
                    
                    // Загружаем сохраненные задачи
                    let savedTasks = self?.taskStorage.fetchTasks() ?? []
                    self?.output?.tasksLoaded(savedTasks)
                    
                case .failure(let error):
                    print("Ошибка загрузки из API: \(error.localizedDescription)")
                    self?.output?.errorOccurred(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchTasks() {
        let tasks = taskStorage.fetchTasks()
        output?.tasksLoaded(tasks)
    }
    
    func toggleTask(_ task: Task) {
        taskStorage.toggleTaskCompletion(task)
        // UI обновится автоматически через CoreData
    }
    
    func deleteTask(_ task: Task) {
        taskStorage.deleteTask(task)
        // Обновляем список после удаления
        fetchTasks()
    }
    
    func searchTasks(_ query: String) {
        let tasks = taskStorage.searchTasks(query: query)
        DispatchQueue.main.async { [weak self] in
            self?.output?.tasksSearchCompleted(tasks)
        }
    }
    
    func clearAllDataAndReload() {
        taskStorage.clearAllTasks()
        loadTasksFromAPI()
    }
} 