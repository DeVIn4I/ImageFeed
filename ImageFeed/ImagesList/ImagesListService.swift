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
                    self.task = nil
                }
            }
        }
        self.task = task
    }
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: String?
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
            let width: Int
            let height: Int
            let createdAt: String
            let description: String?
            let urls: UrlsResult
            let likedByUser: Bool
        
        func convertToPhoto() -> Photo {
            Photo(id: id, size: CGSize(width: width, height: height),
                  createdAt: createdAt, welcomeDescription: description,
                  thumbImageURL: self.urls.thumb, largeImageURL: self.urls.full,
                  isLiked: likedByUser)
            
        }
        
    }
}
