import Foundation

final class ImagesListService {
     
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        let request = URLRequest.makeHTTPRequest(path: "photos?page=\(nextPage)&per_page=10", token: OAuth2TokenStorage.shared.token)
        let task = URLSession.shared.dataTask(type: [PhotoResult].self, for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let photoResult):
                    self.photos.append(contentsOf: photoResult.map { $0.convertToPhoto() })
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.task = nil
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        let isLiked: Bool
    }
    
    struct UrlsResult: Decodable {
        let full: String
        let thumb: String
    }
    
    struct PhotoResult: Decodable {
        let id: String
        let width: Double
        let height: Double
        let createdAt: Date?
        let description: String?
        let likeByUser: Bool
        let urls: UrlsResult
        
        func convertToPhoto() -> Photo {
            return Photo(id: id, size: CGSize(width: width, height: height), createdAt: createdAt, welcomeDescription: description, thumbImageURL: self.urls.thumb, largeImageURL: self.urls.full, isLiked: likeByUser)
        }
    }
}
