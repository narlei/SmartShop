import Foundation

public protocol NetworkServiceProtocol {
    func fetchTasks() async throws -> [Task]
    func addTask(_ task: Task) async throws
    func updateTask(_ task: Task) async throws
    func deleteTask(id: String) async throws
}

public struct Task: Codable, Identifiable {
    public let id: String
    public var title: String
    public var isCompleted: Bool
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case networkUnavailable
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data found"
        case .decodingError:
            return "Data decoding error"
        case .serverError(let code):
            return "Server error: \(code)"
        case .networkUnavailable:
            return "Network unavailable"
        }
    }
}
