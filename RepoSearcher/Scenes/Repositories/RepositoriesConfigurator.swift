final class RepositoriesConfigurator {
    static func configureScene(around viewController: RepositoriesViewController,
                               queryString: String,
                               networkClient: NetworkClientInterface) {
        
        let router = RepositoriesRouter(navigationController: viewController.navigationController) // what to do with navigation controller
        let presenter = RepositoriesPresenter(viewController: viewController)
        let interactor = RepositoriesInteractor(presenter: presenter, queryString: queryString, networkClient: networkClient)

        viewController.router = router
        viewController.interactor = interactor
    }
}
