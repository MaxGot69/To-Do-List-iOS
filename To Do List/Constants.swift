import Foundation

// MARK: - App Constants
// Константы приложения для переиспользования

struct Constants {
    
    // MARK: - API
    struct API {
        static let baseURL = "https://dummyjson.com"
        static let todosEndpoint = "/todos"
        static let todosURL = baseURL + todosEndpoint
    }
    
    // MARK: - CoreData
    struct CoreData {
        static let modelName = "To_Do_List"
        static let containerName = "To_Do_List"
    }
    
    // MARK: - UI Colors
    struct Colors {
        static let primaryBackground = "PrimaryBackground"
        static let secondaryBackground = "SecondaryBackground"
        static let primaryText = "PrimaryText"
        static let secondaryText = "SecondaryText"
        static let accentYellow = "AccentYellow"
        static let accentPurple = "AccentPurple"
        static let accentBlue = "AccentBlue"
        static let accentGreen = "AccentGreen"
        static let accentRed = "AccentRed"
        static let divider = "Divider"
    }
    
    // MARK: - UI Values
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        static let avatarSize: CGFloat = 32
        static let checkboxSize: CGFloat = 24
        static let iconSize: CGFloat = 20
        static let spacing: CGFloat = 16
        static let smallSpacing: CGFloat = 8
        static let largeSpacing: CGFloat = 24
    }
    
    // MARK: - Messages
    struct Messages {
        static let loadingError = "Ошибка загрузки задач"
        static let saveError = "Ошибка сохранения задачи"
        static let deleteError = "Ошибка удаления задачи"
        static let searchPlaceholder = "Поиск задач..."
        static let addTaskTitle = "Новая задача"
        static let editTaskTitle = "Редактировать задачу"
        static let deleteConfirmation = "Удалить задачу?"
        static let deleteMessage = "Это действие нельзя отменить"
        static let cancel = "Отмена"
        static let delete = "Удалить"
        static let save = "Сохранить"
        static let edit = "Редактировать"
        static let share = "Поделиться"
    }
    
    // MARK: - Date Format
    struct DateFormat {
        static let taskDate = "dd/MM/yy"
        static let taskTime = "HH:mm"
    }
} 