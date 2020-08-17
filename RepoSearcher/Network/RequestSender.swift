import Foundation

enum RequestSenderError: Error {
    case invalidUrl
}

protocol RequestSenderInterface {
    static func sendRequest(_ url: String,
                            parameters: [String: String],
                            completion: @escaping (Data?, Error?) -> Void)
}

final class RequestSender: RequestSenderInterface {
    static func sendRequest(_ url: String,
                            parameters: [String: String],
                            completion: @escaping (Data?, Error?) -> Void) {

        guard var components = URLComponents(string: url) else {
            completion(nil, RequestSenderError.invalidUrl)
            return
        }

        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        let request = URLRequest(url: components.url!)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, error)
                    return
            }

            completion(data, nil)
        }
        
        task.resume()
    }
}
