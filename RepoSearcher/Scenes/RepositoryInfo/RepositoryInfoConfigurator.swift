final class RepositoryInfoConfigurator {
    static func configureScene(around viewController: RepositoryInfoViewController,
                               repositoryName: String,
                               repositoryOwnerLogin: String,
                               numberOfForks: Int,
                               networkClient: NetworkClientInterface) {

        let router = RepositoryInfoRouter(navigationController: viewController.navigationController,
                                          networkClient: networkClient)
        let presenter = RepositoryInfoPresenter(viewController: viewController)
        let interactor = RepositoryInfoInteractor(repositoryName: repositoryName,
                                            repositoryOwnerLogin: repositoryOwnerLogin,
                                            numberOfForks: numberOfForks,
                                            presenter: presenter,
                                            networkClient: networkClient)

        viewController.router = router
        viewController.interactor = interactor
    }
}
