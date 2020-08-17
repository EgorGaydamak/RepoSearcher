import Foundation

enum NetworkClientError: Error {
    case requestFailed
}

protocol NetworkClientInterface {
    func searchRepositories(queryString: String,
                            itemsPerPage: Int?,
                            page: Int?,
                            completion: @escaping ([Repository]?, Error?) -> Void)
}

final class NetworkClient: NetworkClientInterface {
    let decoder = JSONDecoder()

    func searchRepositories(queryString: String, itemsPerPage: Int?, page: Int?, completion: @escaping ([Repository]?, Error?) -> Void) {
        var parameters =  ["q" : queryString]

        if let itemsPerPage = itemsPerPage {
            parameters["per_page"] = String(itemsPerPage)
        }

        if let page = page {
            parameters["page"] = String(page)
        }

        RequestSender.sendRequest("https://api.github.com/search/repositories", parameters: parameters) { [weak self] (data, error) in

            if let error = error {
                completion(nil, error)
            } else if
                let data = data,
                let response = try? self?.decoder.decode(RepositoriesSearchResponse.self, from: data) {

                completion(response.items, nil)
            } else {
                completion(nil, NetworkClientError.requestFailed)
            }
        }
    }
}
