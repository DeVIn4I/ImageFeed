import Foundation

enum EndPoint: String {
    case me = "me"
    
}


//MARK: HTTP Request
extension URLRequest {
        enum HTTPMethod: String { case GET, POST, DELETE, PUT }
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
    
    static func makeHTTPRequest(
        path: EndPoint,
        httpMethod: HTTPMethod = .GET,
        baseURL: URL = defaultBaseURL,
        token: String? = OAuth2TokenStorage().token
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path.rawValue, relativeTo: baseURL)!)
        request.httpMethod = httpMethod.rawValue
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
