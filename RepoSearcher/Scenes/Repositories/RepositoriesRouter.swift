import UIKit

protocol RepositoriesRouterInterface {
    init(navigationController: UINavigationController?,
         networkClient: NetworkClientInterface)

    func goToRepositoryInfo(repositoryName: String,
                            repositoryOwnerLogin: String,
                            numberOfForks: Int)
}

final class RepositoriesRouter: RepositoriesRouterInterface {
    private weak var navigationController: UINavigationController?
    private var networkClient: NetworkClientInterface

    init(navigationController: UINavigationController?, networkClient: NetworkClientInterface) {
        self.navigationController = navigationController
        self.networkClient = networkClient
    }

    func goToRepositoryInfo(repositoryName: String, repositoryOwnerLogin: String, numberOfForks: Int) {
        let viewController = RepositoryInfoViewController(nibName: "RepositoryInfoViewController", bundle: nil)

        navigationController?.pushViewController(viewController, animated: true)

        RepositoryInfoConfigurator.configureScene(around: viewController,
                                            repositoryName: repositoryName,
                                            repositoryOwnerLogin: repositoryOwnerLogin,
                                            numberOfForks: numberOfForks,
                                            networkClient: networkClient)
    }
}
