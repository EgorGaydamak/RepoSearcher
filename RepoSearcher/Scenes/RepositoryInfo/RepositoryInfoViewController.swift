import UIKit

protocol RepositoryInfoViewControllerInterface: class {
    var interactor: RepositoryInfoInteractorInterface? { get set }
    var router: RepositoryInfoRouterInterface? { get set }

    func showForkOwners(viewModels: [UserViewModel],
                        totalCount: Int,
                        newIndexPathsToReload: [IndexPath]?)

    func set(repositoryName: String)
    func set(ownerName: String)

    func goToRepositories(userLogin: String)
}

final class RepositoryInfoViewController: UIViewController, RepositoryInfoViewControllerInterface {
    var interactor: RepositoryInfoInteractorInterface?
    var router: RepositoryInfoRouterInterface?

    private var totalForkOwnersCount: Int = 0
    private var forkOwnersViewModels: [UserViewModel] = []

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var ownerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "userCell")

        indicatorView.startAnimating()

        interactor?.fetchForkOwners()
    }

    func showForkOwners(viewModels: [UserViewModel],
                        totalCount: Int,
                        newIndexPathsToReload: [IndexPath]?) {

        forkOwnersViewModels.append(contentsOf: viewModels)
        totalForkOwnersCount = totalCount

        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()

            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload, tableView: tableView)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func set(repositoryName: String) {
        self.title = repositoryName
    }

    func set(ownerName: String) {
        ownerButton.setTitle(ownerName, for: .normal)
    }

    func goToRepositories(userLogin: String) {
        router?.goToRepositories(userLogin: userLogin)
    }

    @IBAction func ownerButtonAction() {
        interactor?.repositoryOwnerButtonTapped()
    }
}

extension RepositoryInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.forkOwnerSelected(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageDownloadingInterface else { return }

        cell.startImageDownloading()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageDownloadingInterface else { return }

        cell.cancelImageDownloading()
    }
}

extension RepositoryInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalForkOwnersCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        if isLoadingCell(for: indexPath, viewModelsCount: forkOwnersViewModels.count) {
            cell.configure(user: .none)
        } else {
            cell.configure(user: forkOwnersViewModels[indexPath.row])
        }

        return cell
    }
}

extension RepositoryInfoViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { isLoadingCell(for: $0, viewModelsCount: forkOwnersViewModels.count) }) {
            interactor?.fetchForkOwners()
        }
    }
}
