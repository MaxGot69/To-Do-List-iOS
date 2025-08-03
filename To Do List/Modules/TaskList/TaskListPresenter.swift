import Foundation
import CoreData

class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol, ObservableObject {
    
    // MARK: - Properties
    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    @Published var tasks: [Task] = []
    @Published var showEditAlert = false
    @Published var showAddTaskSheet = false
    @Published var editingTask: Task?
    @Published var editTitle = ""
    @Published var editDescription = ""
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        print("Приложение запущено - загружаю данные из API")
        interactor?.loadTasksFromAPI()
    }
    
    func viewWillAppear() {
        interactor?.fetchTasks()
    }
    
    // MARK: - User Actions
    func didSelectTask(_ task: Task) {
        print("Выбрана задача: \(task.title ?? "")")
        router?.navigateToTaskDetail(task)
    }
    
    func didTapAddTask() {
        print("Нажата кнопка добавления задачи")
        showAddTaskSheet = true
    }
    
    func didToggleTask(_ task: Task) {
        print("Переключение статуса задачи: \(task.title ?? "")")
        interactor?.toggleTask(task)
        
        // Обновляем список после переключения
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func didDeleteTask(_ task: Task) {
        print("Удаление задачи: \(task.title ?? "")")
        interactor?.deleteTask(task)
        
        // Обновляем список после удаления
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func didTapEditTask(_ task: Task?) {
        guard let task = task else { return }
        print("Редактирование задачи: '\(task.title ?? "")'")
        
        // Устанавливаем данные для редактирования
        editingTask = task
        editTitle = task.title ?? ""
        editDescription = task.taskDescription ?? ""
        showEditAlert = true
    }
    
    func didTapShareTask(_ task: Task?) {
        print("Шаринг задачи: '\(task?.title ?? "")'")
        // TODO: Реализовать шаринг
        view?.showError("Шаринг будет реализован в следующей версии")
    }
    
    func didSearchTasks(_ query: String) {
        print("Поиск задач с запросом: '\(query)'")
        if query.isEmpty {
            // Если поиск пустой, загружаем все задачи
            interactor?.fetchTasks()
        } else {
            // Иначе ищем задачи
            interactor?.searchTasks(query)
        }
    }
    
    func saveEditedTask() {
        guard let task = editingTask else { return }
        
        print("Сохраняю отредактированную задачу: '\(editTitle)'")
        
        // Обновляем задачу в CoreData
        task.title = editTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        task.taskDescription = editDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : editDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Сохраняем изменения
        let taskStorage = TaskStorage()
        taskStorage.updateTask(task)
        
        // Обновляем список
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
        
        // Сбрасываем состояние редактирования
        editingTask = nil
        editTitle = ""
        editDescription = ""
        showEditAlert = false
    }
    
    func taskCreated() {
        print("Новая задача создана, обновляю список")
        // Обновляем список задач после создания новой
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func taskCreatedFromAddTask() {
        print("Задача создана из AddTask модуля, обновляю список")
        // Обновляем список задач после создания новой
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func forceReloadFromAPI() {
        print("Принудительная перезагрузка данных из API")
        interactor?.forceReloadFromAPI()
    }
    
    func clearAllDataAndReload() {
        print("Очищаю все данные и перезагружаю")
        // Сначала очищаем данные
        let taskStorage = TaskStorage()
        taskStorage.clearAllTasks()
        
        // Затем перезагружаем из API
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.loadTasksFromAPI()
        }
    }
    
    // MARK: - Interactor Output
    func tasksLoaded(_ tasks: [Task]) {
        print("Загружено \(tasks.count) задач из CoreData")
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks
            self?.view?.showTasks(tasks)
        }
    }
    
    func loadingStarted() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showLoading()
        }
    }
    
    func loadingFinished() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.hideLoading()
        }
    }
    
    func errorOccurred(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(message)
        }
    }
    
    func taskDeleted() {
        print("Задача удалена")
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func tasksSearchCompleted(_ tasks: [Task]) {
        print("Поиск завершен, найдено \(tasks.count) задач")
        print("Детали найденных задач:")
        for (index, task) in tasks.enumerated() {
            print("  \(index + 1). ID=\(task.id ?? "nil"), Title='\(task.title ?? "nil")', Completed=\(task.isCompleted)")
        }
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks
            self?.view?.showSearchResults(tasks)
        }
    }
} 