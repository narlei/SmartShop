import Foundation

public struct TaskItem {
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

public protocol HomeViewControllerProtocol: AnyObject {
    func presentHome()
}

public protocol HomeFactoryProtocol {
    static func makeHomeViewController() -> HomeViewControllerProtocol
}
