import Foundation
import CoreData

// MARK: - AddTask Presenter
// Presenter управляет данными между View и Interactor для создания задач

final class AddTaskPresenter: AddTaskPresenterProtocol, AddTaskInteractorOutputProtocol, ObservableObject {
    var view: AddTaskViewProtocol?
    var interactor: AddTaskInteractorProtocol?
    var router: AddTaskRouterProtocol?
    
    // MARK: - AddTaskPresenterProtocol
    func viewDidLoad() {
        // View is ready
    }
    
    func didTapSave() {
        // This will be handled by the view directly
        // The view will call interactor with the form data
    }
    
    func didTapCancel() {
        // This will be handled by the view directly
        // The view will dismiss itself
    }
    
    // MARK: - AddTaskInteractorOutputProtocol
    func taskCreated() {
        print("Задача создана, закрываю экран")
        view?.taskCreated()
        
        // Уведомляем TaskListPresenter о создании задачи
        NotificationCenter.default.post(name: NSNotification.Name("TaskCreated"), object: nil)
    }
    
    func loadingStarted() {
        view?.showLoading()
    }
    
    func loadingFinished() {
        view?.hideLoading()
    }
    
    func errorOccurred(_ message: String) {
        view?.showError(message)
    }
} 