import Foundation
import CoreData

// MARK: - TaskList View Protocol
protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task])
    func showSearchResults(_ tasks: [Task])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

// MARK: - TaskList Presenter Protocol
protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectTask(_ task: Task)
    func didTapAddTask()
    func didToggleTask(_ task: Task)
    func didDeleteTask(_ task: Task)
    func didTapEditTask(_ task: Task?)
    func didLongPressTask(_ task: Task)
    func didSearchTasks(_ query: String)
    func saveEditedTask()
    func taskCreated()
    func clearAllDataAndReload()
}

// MARK: - TaskList Interactor Protocol
protocol TaskListInteractorProtocol: AnyObject {
    func loadTasksFromAPI()
    func fetchTasks()
    func toggleTask(_ task: Task)
    func deleteTask(_ task: Task)
    func searchTasks(_ query: String)
    func clearAllDataAndReload()
}

// MARK: - TaskList Interactor Output Protocol
protocol TaskListInteractorOutputProtocol: AnyObject {
    func tasksLoaded(_ tasks: [Task])
    func tasksSearchCompleted(_ tasks: [Task])
    func taskCreated()
    func errorOccurred(_ message: String)
}

// MARK: - TaskList Router Protocol
protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(_ task: Task)
    func navigateToAddTask()
} 