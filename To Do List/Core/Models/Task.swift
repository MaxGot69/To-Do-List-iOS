import Foundation
import CoreData

// MARK: - Task Entity
// Этот файл содержит модель Task для CoreData
// Entity - это модель данных в VIPER архитектуре

struct TaskModel {
    let id: String
    let title: String
    let taskDescription: String?
    let createdDate: Date
    let isCompleted: Bool
    
    init(id: String, title: String, taskDescription: String? = nil, createdDate: Date = Date(), isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.createdDate = createdDate
        self.isCompleted = isCompleted
    }
}

// MARK: - Task CoreData Entity
// Этот класс будет сгенерирован автоматически CoreData
// на основе модели данных в .xcdatamodeld файле 
