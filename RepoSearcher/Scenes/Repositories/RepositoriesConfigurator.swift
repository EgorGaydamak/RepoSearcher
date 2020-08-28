final class RepositoriesConfigurator {
    static func configureScene(around viewController: RepositoriesViewController,
                               queryString: String,
                               networkClient: NetworkClientInterface) {
        
        return configureScene(around: viewController,
                              interactorMode: .search(query: queryString),
                              networkClient: networkClient)
    }

    static func configureScene(around viewController: RepositoriesViewController,
                               userLogin: String,
                               networkClient: NetworkClientInterface) {

        return configureScene(around: viewController,
                              interactorMode: .userRepositories(login: userLogin),
                              networkClient: networkClient)
    }

    private static func configureScene(around viewController: RepositoriesViewController,
                                       interactorMode: RepositoriesInteractorMode,
                                       networkClient: NetworkClientInterface) {

        let router = RepositoriesRouter(navigationController: viewController.navigationController) // what to do with navigation controller
        let presenter = RepositoriesPresenter(viewController: viewController)
        let interactor = RepositoriesInteractor(mode: interactorMode,
                                                presenter: presenter,
                                                networkClient: networkClient)

        viewController.router = router
        viewController.interactor = interactor
    }
}
