import Foundation
import CoreData

// MARK: - TaskDetail Presenter
// Presenter управляет данными между View и Interactor для деталей задачи

class TaskDetailPresenter: TaskDetailPresenterProtocol, TaskDetailInteractorOutputProtocol, ObservableObject {
    var view: TaskDetailViewProtocol?
    var interactor: TaskDetailInteractorProtocol?
    var router: TaskDetailRouterProtocol?
    
    private var currentTask: Task?
    
    // MARK: - TaskDetailPresenterProtocol
    func viewDidLoad() {
        // View is ready
    }
    
    func setTask(_ task: Task) {
        currentTask = task
        view?.showTask(task)
    }
    
    func didTapEdit() {
        // Navigate to edit task
        if let task = currentTask {
            router?.navigateToEditTask(task)
        }
    }
    
    func didTapDelete() {
        guard let task = currentTask else { return }
        
        view?.showLoading()
        interactor?.deleteTask(task)
    }
    
    func didTapBack() {
        // This will be handled by the view directly
        // The view will dismiss itself
    }
    
    // MARK: - TaskDetailInteractorOutputProtocol
    func taskDeleted() {
        view?.hideLoading()
        view?.taskDeleted()
    }
    
    func loadingStarted() {
        view?.showLoading()
    }
    
    func loadingFinished() {
        view?.hideLoading()
    }
    
    func errorOccurred(_ message: String) {
        view?.hideLoading()
        view?.showError(message)
    }
} 