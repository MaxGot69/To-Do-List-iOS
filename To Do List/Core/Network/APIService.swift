import Foundation

// MARK: - API Service
// Базовый сервис для работы с HTTP запросами
// Использует URLSession для сетевых запросов

class APIService {
    static let shared = APIService()
    private let baseURL = "https://dummyjson.com"
    
    init() {}
    
    // MARK: - Generic GET Request
    func fetch<T: Decodable>(from endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch _ as DecodingError {
            throw APIError.decodingError
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Data Fetching
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
} 
