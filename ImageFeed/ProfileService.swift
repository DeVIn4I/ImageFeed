//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Pavel Razumov on 27.01.2023.
//

import Foundation

typealias ProfileBlock = (Result<ProfileService.Profile, Error>) -> Void

class ProfileService {
    
    struct ProfileResult: Decodable {
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        var profile: Profile {
            let name = [firstName, lastName].compactMap { $0 }.joined(separator: " ")
            return Profile(username: username,
                    name: name,
                    loginName: "@\(username)",
                    bio: bio)
        }
    }
    
    struct Profile {
        let username: String
        let name: String?
        let loginName: String?
        let bio: String?
    }
    
    func fetchProfile(completion: ProfileBlock?) {
        let request = URLRequest.makeHTTPRequest(path: "me", token: OAuth2TokenStorage().token)
        
        URLSession.shared.dataTask(type: ProfileResult.self, for: request) { result in
            switch result {
            case .success(let model):
                completion?(.success(model.profile))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
