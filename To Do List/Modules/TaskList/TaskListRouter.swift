import SwiftUI

// MARK: - TaskList Router
// Router отвечает за навигацию между экранами
// Создает и настраивает другие модули

class TaskListRouter: TaskListRouterProtocol {
    
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
        print("Навигация к деталям задачи: \(task.title ?? "")")
        // Navigation is handled by NavigationStack
    }
    
    func navigateToAddTask() {
        print("Навигация к экрану добавления задачи")
        // Navigation is handled by NavigationStack
    }
} 