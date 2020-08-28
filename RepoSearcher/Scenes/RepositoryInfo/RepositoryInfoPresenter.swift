import UIKit

protocol RepositoryInfoPresenterInterface {
    init(viewController: RepositoryInfoViewControllerInterface)

    func present(forkOwners: [User], pageNumber: Int, totalCount: Int)

    func display(repositoryName: String)
    func display(ownerName: String)

    func showRepositories(forOwnerAt index: Int)
    func showRepositories(for login: String)
}

final class RepositoryInfoPresenter: RepositoryInfoPresenterInterface {
    private weak var viewController: RepositoryInfoViewControllerInterface?

    private var forkOwners: [User] = []

    required init(viewController: RepositoryInfoViewControllerInterface) {
        self.viewController = viewController
    }

    func present(forkOwners: [User], pageNumber: Int, totalCount: Int) {
        self.forkOwners.append(contentsOf: forkOwners)


        var indexPathsToReload: [IndexPath]?
        if pageNumber > 1 {
            indexPathsToReload = PagingPresenterHelper.calculateIndexPathsToReload(allItemsCount: self.forkOwners.count,
                                                                                   newItemsCount: forkOwners.count,
                                                                                   section: 0)
        }

        let viewModels = forkOwners.map { UserViewModel(avatarUrl: $0.avatarUrl,
                                                        login: $0.login) }

        DispatchQueue.main.async {
            self.viewController?.showForkOwners(viewModels: viewModels,
                                                totalCount: totalCount,
                                                newIndexPathsToReload: indexPathsToReload)
        }
    }

    func display(repositoryName: String) {
        DispatchQueue.main.async {
            self.viewController?.set(repositoryName: repositoryName)
        }
    }

    func display(ownerName: String) {
        DispatchQueue.main.async {
            self.viewController?.set(ownerName: ownerName)
        }
    }

    func showRepositories(forOwnerAt index: Int) {
        viewController?.goToRepositories(userLogin: forkOwners[index].login)
    }

    func showRepositories(for login: String) {
        viewController?.goToRepositories(userLogin: login)
    }
}
