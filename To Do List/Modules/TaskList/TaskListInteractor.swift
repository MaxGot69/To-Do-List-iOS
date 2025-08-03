import Foundation
import CoreData

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Properties
    weak var output: TaskListInteractorOutputProtocol?
    private let taskAPI = TaskAPI()
    private let taskStorage = TaskStorage()
    
    // MARK: - TaskListInteractorProtocol
    func loadTasksFromAPI() {
        print("Начинаю загрузку данных из API...")
        
        // Проверяем, есть ли уже данные в CoreData
        let existingTasks = taskStorage.fetchTasks()
        if !existingTasks.isEmpty {
            print("В CoreData уже есть \(existingTasks.count) задач, пропускаю загрузку из API")
            output?.tasksLoaded(existingTasks)
            return
        }
        
        output?.loadingStarted()
        
        taskAPI.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                self?.output?.loadingFinished()
                
                switch result {
                case .success(let taskModels):
                    print("Получено \(taskModels.count) задач из API")
                    
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
        output?.taskDeleted()
    }
    
    func searchTasks(_ query: String) {
        print("Выполняю поиск задач с запросом: '\(query)'")
        let tasks = taskStorage.searchTasks(query: query)
        print("Найдено \(tasks.count) задач")
        DispatchQueue.main.async { [weak self] in
            self?.output?.tasksSearchCompleted(tasks)
        }
    }
    
    func forceReloadFromAPI() {
        print("Принудительная перезагрузка из API")
        // Сначала очищаем данные
        taskStorage.clearAllTasks()
        // Затем загружаем из API
        loadTasksFromAPI()
    }
} 