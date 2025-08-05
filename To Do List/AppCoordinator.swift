import SwiftUI
import CoreData

// MARK: - App Coordinator
// Главный координатор приложения
// Управляет навигацией между модулями и инициализацией

final class AppCoordinator: ObservableObject {
    @Published var currentView: AnyView?
    
    init() {
        setupInitialView()
    }
    
    // MARK: - Setup Initial View
    private func setupInitialView() {
        let taskListView = TaskListRouter.createModule()
        currentView = AnyView(
            NavigationStack {
                taskListView
                    .navigationDestination(for: Task.self) { task in
                        TaskDetailRouter.createModule(with: task)
                    }
                    .navigationDestination(for: AddTaskDestination.self) { _ in
                        AddTaskRouter.createModule()
                    }
            }
        )
    }
    
    // MARK: - Navigation Methods
    func navigateToTaskDetail(_ task: Task) {
        // Navigation will be handled by NavigationStack
    }
    
    func navigateToAddTask() {
        // Navigation will be handled by NavigationStack
    }
    
    func navigateBack() {
        // Navigation will be handled by NavigationStack
    }
}

// MARK: - Navigation Destinations
struct AddTaskDestination: Hashable {
    let id = UUID()
} 
