import Foundation

enum NetworkClientError: Error {
    case requestFailed
}

protocol NetworkClientInterface {
    func getUserInfo(login: String,
                     completion: @escaping (Result<User, Error>) -> Void)

    func fetchRepositories(url: String,
                           itemsPerPage: Int?,
                           page: Int?,
                           completion: @escaping (Result<[Repository], Error>) -> Void)

    func searchRepositories(queryString: String,
                            itemsPerPage: Int?,
                            page: Int?,
                            completion: @escaping (Result<RepositoriesSearchResponse, Error>) -> Void)

    func fetchForks(repositoryName: String,
                    repositoryOwnerLogin: String,
                    itemsPerPage: Int?,
                    page: Int?,
                    completion: @escaping (Result<[Fork], Error>) -> Void)
}

final class NetworkClient: NetworkClientInterface {
    let decoder = JSONDecoder()

    func getUserInfo(login: String,
                     completion: @escaping (Result<User, Error>) -> Void) {

        sendRequest(url: "https://api.github.com/users/" + login,
                    parameters: nil,
                    completion: completion)
    }

    func fetchRepositories(url: String,
                           itemsPerPage: Int?,
                           page: Int?,
                           completion: @escaping (Result<[Repository], Error>) -> Void) {

        sendPagingRequest(url: url,
                          parameters: nil,
                          itemsPerPage: itemsPerPage,
                          page: page,
                          completion: completion)
    }

    func searchRepositories(queryString: String, itemsPerPage: Int?, page: Int?, completion: @escaping (Result<RepositoriesSearchResponse, Error>) -> Void) {

        sendPagingRequest(url: "https://api.github.com/search/repositories",
                          parameters: ["q" : queryString],
                          itemsPerPage: itemsPerPage,
                          page: page,
                          completion: completion)
    }

    func fetchForks(repositoryName: String,
                    repositoryOwnerLogin: String,
                    itemsPerPage: Int?,
                    page: Int?,
                    completion: @escaping (Result<[Fork], Error>) -> Void) {

        sendPagingRequest(url: "https://api.github.com/repos/\(repositoryOwnerLogin)/\(repositoryName)/forks",
            parameters: nil,
            itemsPerPage: itemsPerPage,
            page: page,
            completion: completion)
    }

    private func sendPagingRequest<T: Decodable>(url: String,
                                                 parameters: [String: String]?,
                                                 itemsPerPage: Int?,
                                                 page: Int?,
                                                 completion: @escaping (Result<T, Error>) -> Void) {

        let mergedParameters = parameters?.merging(getPagingParameters(itemsPerPage: itemsPerPage, page: page),
                                                   uniquingKeysWith: { (first, _) in first })

        sendRequest(url: url,
                    parameters: mergedParameters,
                    completion: completion)
    }

    private func sendRequest<T: Decodable>(url: String,
                                           parameters: [String: String]?,
                                           completion: @escaping (Result<T, Error>) -> Void) {

        RequestSender.sendRequest(url, parameters: parameters) { [weak self] (data, error) in

            if let error = error {
                completion(.failure(error))
            } else if
                let data = data,
                let response = try? self?.decoder.decode(T.self, from: data) {

                completion(.success(response))
            } else {
                completion(.failure(NetworkClientError.requestFailed))
            }
        }
    }

    private func getPagingParameters(itemsPerPage: Int?, page: Int?) -> [String: String] {
        var parameters: [String: String] = [:]

        if let itemsPerPage = itemsPerPage {
            parameters["per_page"] = String(itemsPerPage)
        }

        if let page = page {
            parameters["page"] = String(page)
        }

        return parameters
    }
}
