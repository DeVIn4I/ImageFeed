import Foundation

final class OAuth2TokenStorage {
    
    private enum Keys: String {
        case bearerToken
    }
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            return userDefaults.string(forKey: Keys.bearerToken.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
}
