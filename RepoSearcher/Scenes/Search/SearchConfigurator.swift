import Foundation

final class SearchConfigurator {
    static func configureScene(around viewController: SearchViewController) {
        let router = SearchRouter(navigationController: viewController.navigationController) // what to do with navigation controller
        let presenter = SearchPresenter(viewController: viewController)
        let interactor = SearchInteractor(presenter: presenter)

        viewController.router = router
        viewController.interactor = interactor
    }
}
