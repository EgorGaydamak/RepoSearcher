protocol SearchInteractorInterface {
    init(presenter: SearchPresenterInterface)

    func searchQueryDidChange(_ text: String?)
    func searchButtonTapped()
}

final class SearchInteractor: SearchInteractorInterface {
    private var presenter: SearchPresenterInterface
    private var searchQueryString: String?

    required init(presenter: SearchPresenterInterface) {
        self.presenter = presenter
    }

    func searchQueryDidChange(_ text: String?) {
        searchQueryString = text
    }

    func searchButtonTapped() {
        presenter.showRepositories(query: searchQueryString)
    }
}
