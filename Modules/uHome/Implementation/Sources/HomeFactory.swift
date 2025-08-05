import UIKit
import HomeInterface

public final class HomeFactory: HomeFactoryProtocol {
    public static func makeHomeViewController() -> HomeViewControllerProtocol {
        return HomeViewController()
    }
}

// Extension to make it easier to use in AppDelegate
public extension HomeFactory {
    static func makeHomeViewControllerAsUIViewController() -> UIViewController {
        return makeHomeViewController() as? UIViewController ?? UIViewController()
    }
}
