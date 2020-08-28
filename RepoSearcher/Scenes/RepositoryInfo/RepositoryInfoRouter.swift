import UIKit

protocol RepositoryInfoRouterInterface {
    init(navigationController: UINavigationController?, networkClient: NetworkClientInterface)

    func goToRepositories(userLogin: String)
}

final class RepositoryInfoRouter: RepositoryInfoRouterInterface {
    private weak var navigationController: UINavigationController?
    private var networkClient: NetworkClientInterface

    init(navigationController: UINavigationController?, networkClient: NetworkClientInterface) {
        self.navigationController = navigationController
        self.networkClient = networkClient
    }

    func goToRepositories(userLogin: String) {
        let viewController = RepositoriesViewController(nibName: "RepositoriesViewController", bundle: nil)
        navigationController?.pushViewController(viewController, animated: true)

        RepositoriesConfigurator.configureScene(around: viewController,
                                                userLogin: userLogin,
                                                networkClient: networkClient)
    }
}
