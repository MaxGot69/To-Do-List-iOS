
import SwiftUI

@main
struct To_Do_ListApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            if let currentView = appCoordinator.currentView {
                currentView
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ProgressView("Загрузка...")
            }
        }
    }
}
