import UIKit

protocol RepositoriesPresenterInterface {
    init(viewController: RepositoriesViewControllerInterface)

    func present(repositories: [Repository], pageNumber: Int, totalCount: Int)
    func display(title: String)

    func showRepository(at index: Int)
}

final class RepositoriesPresenter: RepositoriesPresenterInterface {
    private weak var viewController: RepositoriesViewControllerInterface?

    private var repositories: [Repository] = []

    required init(viewController: RepositoriesViewControllerInterface) {
        self.viewController = viewController
    }

    func present(repositories: [Repository], pageNumber: Int, totalCount: Int) {
        self.repositories.append(contentsOf: repositories)


        var indexPathsToReload: [IndexPath]?
        if pageNumber > 1 {
            indexPathsToReload = PagingPresenterHelper.calculateIndexPathsToReload(allItemsCount: self.repositories.count,
                                                                                   newItemsCount: repositories.count,
                                                                                   section: 0)
        }

        let viewModels = repositories.map { RepositoryViewModel(name: $0.name,
                                                                description: $0.description ?? "",
                                                                numberOfForks: String($0.forks),
                                                                numberOfWatchers: String($0.watchers),
                                                                ownerAvatarUrl: $0.owner.avatarUrl) }

        DispatchQueue.main.async {
            self.viewController?.showRepositories(viewModels: viewModels,
                                                  totalCount: totalCount,
                                                  newIndexPathsToReload: indexPathsToReload)
        }
    }

    func display(title: String) {
        DispatchQueue.main.async {
            self.viewController?.setTitle(title: title)
        }
    }

    func showRepository(at index: Int) {
        let repository = repositories[index]

        if repository.forks > 0 {
            viewController?.goToRepositoryInfo(repositoryName: repository.name,
                                               repositoryOwnerLogin: repository.owner.login,
                                               numberOfForks: repository.forks)
        }
    }
}
