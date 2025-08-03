import Foundation
import CoreData

// MARK: - AddTask VIPER Protocols

// MARK: - View Protocol
protocol AddTaskViewProtocol {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func taskCreated()
}

// MARK: - Presenter Protocol
protocol AddTaskPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave()
    func didTapCancel()
}

// MARK: - Interactor Protocol
protocol AddTaskInteractorProtocol: AnyObject {
    func createTask(title: String, description: String?)
}

// MARK: - Router Protocol
protocol AddTaskRouterProtocol: AnyObject {
    func navigateBack()
}

// MARK: - Interactor Output Protocol
protocol AddTaskInteractorOutputProtocol: AnyObject {
    func taskCreated()
    func loadingStarted()
    func loadingFinished()
    func errorOccurred(_ message: String)
} 