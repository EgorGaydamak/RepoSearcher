import UIKit

protocol SearchViewControllerInterface: class {
    var interactor: SearchInteractorInterface? { get set }
    var router: SearchRouterInterface? { get set }

    func goToRepositories(query: String?)
}

final class SearchViewController: UIViewController, SearchViewControllerInterface {
    var interactor: SearchInteractorInterface?
    var router: SearchRouterInterface?

    @IBOutlet private weak var queryTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextField()
        prepareForQueryInput()
    }

    func goToRepositories(query: String?) {
        router?.goToRepositories(queryString: query ?? "", //TODO:
                                 networkClient: NetworkClient())
    }

    private func configureTextField() {
        queryTextField.delegate = self
        queryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func prepareForQueryInput() {
        queryTextField.becomeFirstResponder()
    }
}

extension SearchViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        interactor?.searchQueryDidChange(textField.text)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        interactor?.searchQueryDidChange(textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        interactor?.searchButtonTapped()

        return true
    }
}
