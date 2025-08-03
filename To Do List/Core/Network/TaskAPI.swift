import Foundation

class TaskAPI {
    
    // MARK: - Properties
    private let apiService = APIService.shared
    
    // MARK: - Fetch Tasks
    func fetchTasks(completion: @escaping (Result<[TaskModel], Error>) -> Void) {
        guard let url = URL(string: Constants.API.todosURL) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        apiService.fetchData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                    let taskModels = self?.convertToTaskModels(todoResponse.todos) ?? []
                    completion(.success(taskModels))
                } catch {
                    completion(.failure(APIError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Convert API Response
    private func convertToTaskModels(_ todoItems: [TodoItem]) -> [TaskModel] {
        print("Начинаю конвертацию \(todoItems.count) задач из API")
        
        let taskModels = todoItems.compactMap { todo -> TaskModel? in
            // Пропускаем задачи с пустыми названиями
            guard !todo.todo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                print("Пропускаю задачу с пустым названием: ID=\(todo.id)")
                return nil
            }
            
            let taskModel = TaskModel(
                id: String(todo.id),
                title: todo.todo.trimmingCharacters(in: .whitespacesAndNewlines),
                taskDescription: nil,
                createdDate: Date(),
                isCompleted: todo.completed
            )
            
            print("Конвертирована задача: ID=\(taskModel.id), Title='\(taskModel.title)', Completed=\(taskModel.isCompleted)")
            return taskModel
        }
        
        print("Успешно конвертировано \(taskModels.count) задач из \(todoItems.count)")
        return taskModels
    }
}

// MARK: - API Models
struct TodoResponse: Codable {
    let todos: [TodoItem]
}

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
} 