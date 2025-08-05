import Foundation
import SwiftUI

// MARK: - TaskDetail Router
// Router отвечает за навигацию для деталей задачи

final class TaskDetailRouter: TaskDetailRouterProtocol {
    var viewController: TaskDetailView?
    
    static func createModule(with task: Task) -> TaskDetailView {
        let interactor = TaskDetailInteractor()
        let presenter = TaskDetailPresenter()
        var view = TaskDetailView(task: task)
        let router = TaskDetailRouter()
        
        // Настройка связей
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateBack() {
        // Navigation is handled by NavigationStack
    }
    
    func navigateToEditTask(_ task: Task) {
        print("Навигация к редактированию задачи: \(task.title ?? "nil")")
        // Navigation is handled by NavigationStack
    }
} 