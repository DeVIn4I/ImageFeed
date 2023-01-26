import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        type: T.Type,
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    completion(.failure(URLSessionError.codeError))
                    return
                }
                
                guard let data else { return }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let model = try decoder.decode(T.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(URLSessionError.decodeError))
                }
            }
        }
        return task
    }
    
    private enum URLSessionError: Error {
        case codeError, decodeError
    }
}

