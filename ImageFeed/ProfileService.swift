import Foundation

final class ProfileService {
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
        
        func makeProfile() -> Profile {
            let profile = Profile(username: username,
                                  name: "\(firstName) \(lastName)",
                                  loginName: "@\(username)",
                                  bio: bio)
            return profile
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
    }
    
    func fetchProfile(_ token: String?, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        enum ProfileError: Error {
            case tokenError
        }
        
        guard let token else {
            completion(.failure(ProfileError.tokenError))
            return
        }
        
        let request = profileRequest()
        let task = object(for: request) { result in
            
            switch result {
            case .success(let model):
                completion(.success(model.makeProfile()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    
        func object(
            for request: URLRequest,
            completion: @escaping (Result<ProfileResult, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<ProfileResult, Error> in
                    Result { try decoder.decode(ProfileResult.self, from: data) }
                }
                completion(response)
            }
        }

        func profileRequest() -> URLRequest {
            URLRequest.makeHTTPRequest(path: "me", httpMethod: .GET, token: token)
        }
        
    }
}
//func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
//    let request = authTokenRequest(code: code)
//    let task = object(for: request) { [weak self] result in
//        guard let self else { return }
//        switch result {
//        case .success(let body):
//            let authToken = body.accessToken
//            self.authToken = authToken
//            completion(.success(authToken))
//        case .failure(let error):
//            completion(.failure(error))
//        }
//    }
//    task.resume()
//}
