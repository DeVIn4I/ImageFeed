import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        if task != nil { return }
        let nextPage = lastLoadedPage
        let request = URLRequest.makeHTTPRequest(path: "photos?page=\(nextPage)&per_page=10", token: OAuth2TokenStorage.shared.token)
        let task = URLSession.shared.dataTask(type: [PhotoResult].self, for: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let photoResult):
                    self.lastLoadedPage += 1
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
}
