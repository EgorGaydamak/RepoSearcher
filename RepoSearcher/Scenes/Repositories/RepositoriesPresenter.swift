import UIKit

protocol RepositoriesPresenterInterface {
    init(viewController: RepositoriesViewControllerInterface)
}

final class RepositoriesPresenter: RepositoriesPresenterInterface {
    private weak var viewController: RepositoriesViewControllerInterface?

    required init(viewController: RepositoriesViewControllerInterface) {
        self.viewController = viewController
    }
}
