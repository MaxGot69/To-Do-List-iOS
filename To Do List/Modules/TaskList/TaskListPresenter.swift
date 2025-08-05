import Foundation
import CoreData

// MARK: - TaskList State
struct TaskListState {
    var selectedTask: Task?
    var editingTask: Task?
    var editTitle: String = ""
    var editDescription: String = ""
    var showActionSheet: Bool = false
}

final class TaskListPresenter: TaskListPresenterProtocol, TaskListInteractorOutputProtocol, ObservableObject {
    
    // MARK: - Properties
    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    @Published var tasks: [Task] = []
    @Published var showEditAlert = false
    @Published var showAddTaskSheet = false
    @Published var state = TaskListState()
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        interactor?.loadTasksFromAPI()
    }
    
    func viewWillAppear() {
        interactor?.fetchTasks()
    }
    
    // MARK: - User Actions
    func didSelectTask(_ task: Task) {
        router?.navigateToTaskDetail(task)
    }
    
    func didTapAddTask() {
        showAddTaskSheet = true
    }
    
    func didToggleTask(_ task: Task) {
        interactor?.toggleTask(task)
        
        // Обновляем список после переключения
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func didDeleteTask(_ task: Task) {
        interactor?.deleteTask(task)
        
        // Обновляем список после удаления
        DispatchQueue.main.async { [weak self] in
            self?.interactor?.fetchTasks()
        }
    }
    
    func didTapEditTask(_ task: Task?) {
        guard let task = task else { return }
        
        // Устанавливаем данные для редактирования
        state.editingTask = task
        state.editTitle = task.title ?? ""
        state.editDescription = task.taskDescription ?? ""
        showEditAlert = true
    }
    
    func didLongPressTask(_ task: Task) {
        state.selectedTask = task
        state.showActionSheet = true
    }
    
    func saveEditedTask() {
        guard let task = state.editingTask else { return }
        
        // Обновляем задачу в CoreData
        task.title = state.editTitle
        task.taskDescription = state.editDescription
        
        do {
            try task.managedObjectContext?.save()
            
            // Обновляем список
            interactor?.fetchTasks()
            
            // Сбрасываем состояние редактирования
            state.editingTask = nil
            state.editTitle = ""
            state.editDescription = ""
            showEditAlert = false
            
        } catch {
            print("Ошибка при обновлении задачи: \(error)")
        }
    }
    
    func clearAllDataAndReload() {
        interactor?.clearAllDataAndReload()
    }
    
    func didSearchTasks(_ query: String) {
        interactor?.searchTasks(query)
    }
    
    // MARK: - TaskListInteractorOutputProtocol
    func tasksLoaded(_ tasks: [Task]) {
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks
        }
    }
    
    func tasksSearchCompleted(_ tasks: [Task]) {
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks
        }
    }
    
    func taskCreated() {
        interactor?.fetchTasks()
    }
    
    func errorOccurred(_ message: String) {
        print("Ошибка: \(message)")
    }
} 