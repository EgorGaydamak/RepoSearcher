import UIKit

protocol RepositoriesRouterInterface: RouterInterface {
    
}

final class RepositoriesRouter: RepositoriesRouterInterface {
    private weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
