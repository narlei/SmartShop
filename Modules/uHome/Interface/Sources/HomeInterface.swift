import Foundation

public protocol HomeViewControllerProtocol: AnyObject {
    func presentHome()
}

public protocol HomeFactoryProtocol {
    static func makeHomeViewController() -> HomeViewControllerProtocol
}
