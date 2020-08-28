enum RepositoriesInteractorMode {
    case search(query: String)
    case userRepositories(login: String)
}

protocol RepositoriesInteractorInterface {
    init(mode: RepositoriesInteractorMode,
         presenter: RepositoriesPresenterInterface,
         networkClient: NetworkClientInterface)

    func fetchRepositories()
    func repositorySelected(index: Int)
}

final class RepositoriesInteractor: RepositoriesInteractorInterface {
    private var mode: RepositoriesInteractorMode
    private var presenter: RepositoriesPresenterInterface
    private var networkClient: NetworkClientInterface

    private let itemsPerPage = 30
    private var isFetchInProgress = false
    private var currentPage = 0
    private var totalItemsCount: Int?

    required init(mode: RepositoriesInteractorMode,
                  presenter: RepositoriesPresenterInterface,
                  networkClient: NetworkClientInterface) {

        self.mode = mode
        self.presenter = presenter
        self.networkClient = networkClient

        switch mode {
        case .search(let query):
            presenter.display(title: "🕵🏻‍♂️ \(query)")
        case .userRepositories(let login):
            presenter.display(title: login)
        }
    }

    func fetchRepositories() {
        guard !isFetchInProgress else {
          return
        }

        isFetchInProgress = true

        switch mode {
        case .search(let query):
            networkClient.searchRepositories(queryString: query, itemsPerPage: itemsPerPage, page: currentPage) { result in
                self.isFetchInProgress = false

                switch result {
                case .success(let response):
                    self.presenter.present(repositories: response.items,
                                           pageNumber: self.currentPage,
                                           totalCount: response.totalCount)

                    self.currentPage += 1
                case .failure(let error):
                    //TODO:
                    print(error)
                }
            }
        case .userRepositories(let login):
            if let totalItemsCount = totalItemsCount {
                let url = "https://api.github.com/users/\(login)/repos"
                networkClient.fetchRepositories(url: url, itemsPerPage: itemsPerPage, page: currentPage) { result in
                    self.isFetchInProgress = false

                    switch result {
                    case .success(let repositories):
                        self.presenter.present(repositories: repositories,
                                               pageNumber: self.currentPage,
                                               totalCount: totalItemsCount)

                        self.currentPage += 1
                    case .failure(let error):
                        //TODO:
                        print(error)
                    }
                }
            } else {
                networkClient.getUserInfo(login: login) { result in
                    self.isFetchInProgress = false

                    switch result {
                    case .success(let user):
                        self.totalItemsCount = user.publicRepositoriesCount
                        self.fetchRepositories()
                    case .failure(let error):
                        //TODO:
                        print(error)
                    }
                }
            }
        }
    }

    func repositorySelected(index: Int) {
        presenter.showRepository(at: index)
    }
}
