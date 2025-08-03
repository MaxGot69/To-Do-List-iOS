import Foundation
import CoreData

// MARK: - View Protocol
protocol TaskDetailViewProtocol {
    func showTask(_ task: Task)
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func taskDeleted()
}

// MARK: - Presenter Protocol
protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func setTask(_ task: Task)
    func didTapEdit()
    func didTapDelete()
    func didTapBack()
}

// MARK: - Interactor Protocol
protocol TaskDetailInteractorProtocol: AnyObject {
    func fetchTask(id: String)
    func deleteTask(_ task: Task)
}

// MARK: - Router Protocol
protocol TaskDetailRouterProtocol: AnyObject {
    func navigateBack()
    func navigateToEditTask(_ task: Task)
}

// MARK: - Interactor Output Protocol
protocol TaskDetailInteractorOutputProtocol: AnyObject {
    func taskDeleted()
    func loadingStarted()
    func loadingFinished()
    func errorOccurred(_ message: String)
} 