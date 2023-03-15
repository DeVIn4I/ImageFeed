import Foundation

let myAccessKey = "FWm9IBeWOQ6bMqZzuengryOeBcbUVI73_IQf2kJC574"
let mySecretKey = "QQyJ6kaOCAD6d2LwARfRBBHMh9kSRGK4lbFBPGS1_do"
let myRedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let myAccessScope = "public+read_user+write_likes"

let defaultBaseUrl = URL(string: "https://api.unsplash.com/")!
let unsplashAuthorizeUrlString = "https://unsplash.com/oauth/authorize"
let tokenURL = "https://unsplash.com/oauth/token"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: myAccessKey,
                                 secretKey: mySecretKey,
                                 redirectURI: myRedirectURI,
                                 accessScope: myAccessScope,
                                 defaultBaseURL: defaultBaseUrl,
                                 authURLString: unsplashAuthorizeUrlString)
    }
}
