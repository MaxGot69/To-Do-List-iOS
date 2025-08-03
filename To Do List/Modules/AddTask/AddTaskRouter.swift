import SwiftUI

// MARK: - AddTask Router
// Router отвечает за навигацию для добавления задач

class AddTaskRouter: AddTaskRouterProtocol {
    var viewController: AddTaskView?
    
    static func createModule() -> AddTaskView {
        let interactor = AddTaskInteractor()
        let presenter = AddTaskPresenter()
        var view = AddTaskView()
        let router = AddTaskRouter()
        
        // Настройка связей
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        // Presenter уже установлен через @StateObject в view
        // Не нужно устанавливать его извне
        
        return view
    }
    
    func navigateBack() {
        // Navigation is handled by NavigationStack
    }
} 