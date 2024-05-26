import Alamofire

class ComicService {
    static let shared = ComicService()
    private let baseURL = "http://localhost:5000/manga/page/"
    
    func fetchComics(forPage page: Int, completion: @escaping (Result<[BasicComic], Error>) -> Void) {
        let url = "\(baseURL)\(page)"
        AF.request(url).responseDecodable(of: ComicResponse.self) { response in
            switch response.result {
            case .success(let comicResponse):
                completion(.success(comicResponse.manga_list))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMultiplePages(totalPages: Int, completion: @escaping (Result<[BasicComic], Error>) -> Void) {
        var allComics: [BasicComic] = []
        var completedRequests = 0
        var encounteredError: Error?
        
        for page in 1...totalPages {
            fetchComics(forPage: page) { result in
                completedRequests += 1
                switch result {
                case .success(let comics):
                    allComics.append(contentsOf: comics)
                case .failure(let error):
                    encounteredError = error
                }
                
                if completedRequests == totalPages {
                    if let error = encounteredError {
                        completion(.failure(error))
                    } else {
                        completion(.success(allComics))
                    }
                }
            }
        }
    }
}
