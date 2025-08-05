import Foundation
import SwiftUI

// MARK: - TaskList Router
// Router отвечает за навигацию между экранами
// Создает и настраивает другие модули

final class TaskListRouter: TaskListRouterProtocol {
    
    static func createModule() -> TaskListView {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter()
        let view = TaskListView(presenter: presenter)
        let router = TaskListRouter()
        
        // Настройка связей
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        
        return view
    }
    
    func navigateToTaskDetail(_ task: Task) {
        // Navigation is handled by NavigationStack
    }
    
    func navigateToAddTask() {
        // Navigation is handled by NavigationStack
    }
} 