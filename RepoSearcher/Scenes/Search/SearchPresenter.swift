protocol SearchPresenterInterface {
    init(viewController: SearchViewControllerInterface)

    func showRepositories(query: String?)
}

final class SearchPresenter: SearchPresenterInterface {
    private weak var viewController: SearchViewControllerInterface?

    required init(viewController: SearchViewControllerInterface) {
        self.viewController = viewController
    }

    func showRepositories(query: String?) {
        viewController?.goToRepositories(query: query)
    }
}
