import UIKit

protocol RepositoriesViewControllerInterface: class {
    var interactor: RepositoriesInteractorInterface? { get set }
    var router: RepositoriesRouterInterface? { get set }
}

final class RepositoriesViewController: UIViewController, RepositoriesViewControllerInterface {
    var interactor: RepositoriesInteractorInterface?
    var router: RepositoriesRouterInterface?

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.fetchRepositories()
    }
}
