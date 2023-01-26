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
            Profile(username: username,
                    name: "\(firstName) \(lastName)",
                    loginName: "@\(username)",
                    bio: bio)
            
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
        
        if let task {
            task.cancel()
        }
         
        guard let token else {
            completion(.failure(ProfileError.tokenError))
            return
        }
        
        let request: URLRequest = .makeHTTPRequest(path: .me)
        
        
        let task = urlSession.objectTask(type: ProfileResult.self, for: request) { result in
            switch result {
            case .success(let model):
                completion(.success(model.makeProfile()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeRequest(with token: String) -> URLRequest {
        var request = URLRequest(url: defaultBaseURL.appendingPathComponent("me"))
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

//struct Network
