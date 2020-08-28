import UIKit

protocol RepositoriesViewControllerInterface: class {
    var interactor: RepositoriesInteractorInterface? { get set }
    var router: RepositoriesRouterInterface? { get set }

    func showRepositories(viewModels: [RepositoryViewModel],
                          totalCount: Int,
                          newIndexPathsToReload: [IndexPath]?)

    func setTitle(title: String)

    func goToRepositoryInfo(repositoryName: String,
                            repositoryOwnerLogin: String,
                            numberOfForks: Int)
}

final class RepositoriesViewController: UIViewController, RepositoriesViewControllerInterface {
    var interactor: RepositoriesInteractorInterface?
    var router: RepositoriesRouterInterface?

    private var totalRepositoriesCount: Int = 0
    private var repositoryViewModels: [RepositoryViewModel] = []
    private var cellHeights: [IndexPath: CGFloat] = [:]

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "repositoryCell")

        indicatorView.startAnimating()

        interactor?.fetchRepositories()
    }

    func showRepositories(viewModels: [RepositoryViewModel],
                          totalCount: Int,
                          newIndexPathsToReload: [IndexPath]?) {

        repositoryViewModels.append(contentsOf: viewModels)
        totalRepositoriesCount = totalCount

        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()

            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload, tableView: tableView)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func setTitle(title: String) {
        self.title = title
    }

    func goToRepositoryInfo(repositoryName: String,
                            repositoryOwnerLogin: String,
                            numberOfForks: Int) {

        router?.goToRepositoryInfo(repositoryName: repositoryName,
                                   repositoryOwnerLogin: repositoryOwnerLogin,
                                   numberOfForks: numberOfForks)
    }
}

extension RepositoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height

        guard let cell = cell as? ImageDownloadingInterface else { return }

        cell.startImageDownloading()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageDownloadingInterface else { return }

        cell.cancelImageDownloading()
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.repositorySelected(index: indexPath.row)
    }
}

extension RepositoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalRepositoriesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTableViewCell
        if isLoadingCell(for: indexPath, viewModelsCount: repositoryViewModels.count) {
            cell.configure(repository: .none)
        } else {
            cell.configure(repository: repositoryViewModels[indexPath.row])
        }

        return cell
    }
}

extension RepositoriesViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { isLoadingCell(for: $0, viewModelsCount: repositoryViewModels.count) }) {
            interactor?.fetchRepositories()
        }
    }
}
