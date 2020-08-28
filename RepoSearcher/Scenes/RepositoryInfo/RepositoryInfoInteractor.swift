protocol RepositoryInfoInteractorInterface {
    init(repositoryName: String,
         repositoryOwnerLogin: String,
         numberOfForks: Int,
         presenter: RepositoryInfoPresenterInterface,
         networkClient: NetworkClientInterface)

    func fetchForkOwners()

    func forkOwnerSelected(index: Int)
    func repositoryOwnerButtonTapped()
}

final class RepositoryInfoInteractor: RepositoryInfoInteractorInterface {
    private var presenter: RepositoryInfoPresenterInterface
    private var networkClient: NetworkClientInterface

    private var repositoryName: String
    private var repositoryOwnerLogin: String

    private let itemsPerPage = 30
    private var isFetchInProgress = false
    private var currentPage = 0
    private var totalItemsCount: Int

    init(repositoryName: String,
         repositoryOwnerLogin: String,
         numberOfForks: Int,
         presenter: RepositoryInfoPresenterInterface,
         networkClient: NetworkClientInterface) {

        self.repositoryName = repositoryName
        self.repositoryOwnerLogin = repositoryOwnerLogin
        self.totalItemsCount = numberOfForks
        self.presenter = presenter
        self.networkClient = networkClient

        presenter.display(repositoryName: repositoryName)

        networkClient.getUserInfo(login: repositoryOwnerLogin) { result in
            if case .success(let user) = result {
                self.presenter.display(ownerName: user.name ?? repositoryOwnerLogin)
            } else {
                self.presenter.display(ownerName: repositoryOwnerLogin)
            }
        }
    }

    func fetchForkOwners() {
        guard !isFetchInProgress else {
          return
        }

        isFetchInProgress = true

        networkClient.fetchForks(repositoryName: repositoryName, repositoryOwnerLogin: repositoryOwnerLogin, itemsPerPage: itemsPerPage, page: currentPage) { result in

            self.isFetchInProgress = false

            switch result {
            case .success(let forks):
                self.presenter.present(forkOwners: forks.map { $0.owner },
                                       pageNumber: self.currentPage,
                                       totalCount: self.totalItemsCount)

                self.currentPage += 1
            case .failure(let error):
                //TODO:
                print(error)
            }
        }
    }

    func forkOwnerSelected(index: Int) {
        presenter.showRepositories(forOwnerAt: index)
    }

    func repositoryOwnerButtonTapped() {
        presenter.showRepositories(for: repositoryOwnerLogin)
    }
}
