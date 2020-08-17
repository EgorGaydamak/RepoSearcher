import UIKit

protocol RouterInterface {
    init(navigationController: UINavigationController?)
}

protocol SearchRouterInterface: RouterInterface {
    func goToRepositories(queryString: String, networkClient: NetworkClientInterface)
}

final class SearchRouter: SearchRouterInterface {
    private weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func goToRepositories(queryString: String, networkClient: NetworkClientInterface) {
        let viewController = RepositoriesViewController(nibName: "RepositoriesViewController", bundle: nil)
        RepositoriesConfigurator.configureScene(around: viewController,
                                                queryString: queryString,
                                                networkClient: networkClient)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
