import UIKit

protocol SearchRouterInterface {
    init(navigationController: UINavigationController?)

    func goToRepositories(queryString: String, networkClient: NetworkClientInterface)
}

final class SearchRouter: SearchRouterInterface {
    private weak var navigationController: UINavigationController?

    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func goToRepositories(queryString: String, networkClient: NetworkClientInterface) {
        let viewController = RepositoriesViewController(nibName: "RepositoriesViewController", bundle: nil)

        navigationController?.pushViewController(viewController, animated: true)

        RepositoriesConfigurator.configureScene(around: viewController,
                                                queryString: queryString,
                                                networkClient: networkClient)
    }
}
