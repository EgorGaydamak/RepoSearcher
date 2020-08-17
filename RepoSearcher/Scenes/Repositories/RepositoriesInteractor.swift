protocol RepositoriesInteractorInterface {
    init(presenter: RepositoriesPresenterInterface, queryString: String, networkClient: NetworkClientInterface)

    func fetchRepositories()
}

final class RepositoriesInteractor: RepositoriesInteractorInterface {
    private var presenter: RepositoriesPresenterInterface
    private var queryString: String
    private var networkClient: NetworkClientInterface

    required init(presenter: RepositoriesPresenterInterface, queryString: String, networkClient: NetworkClientInterface) {
        self.presenter = presenter
        self.queryString = queryString
        self.networkClient = networkClient
    }

    func fetchRepositories() {
        networkClient.searchRepositories(queryString: queryString,
                                         itemsPerPage: nil,
                                         page: nil) { (repos, error) in
                                            //TODO:
        }
    }
}
