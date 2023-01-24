import Foundation

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: .bearerToken)
        }
        set {
            if let token = newValue {
                userDefaults.set(token, forKey: .bearerToken)
            } else {
                userDefaults.removeObject(forKey: .bearerToken)
            }
        }
    }
}

extension String {
    static let bearerToken = "bearerToken"
}
