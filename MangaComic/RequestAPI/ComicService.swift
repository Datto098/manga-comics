import Alamofire

class ComicService {
    static let shared = ComicService()
    private let baseURL = "http://localhost:5000/manga/page/"
    
    func fetchComics(forPage page: Int, completion: @escaping ([BasicComic]) -> Void) {
        let url = "\(baseURL)\(page)"
        AF.request(url).responseDecodable(of: ComicResponse.self) { response in
            switch response.result {
            case .success(let comicResponse):
//                print(comicResponse.manga_list[0])
                completion(comicResponse.manga_list)
            case .failure(let error):
                print("Failed to fetch comics for page \(page): \(error)")
                completion([])
            }
        }
    }
    
    func fetchMultiplePages(totalPages: Int, completion: @escaping ([BasicComic]) -> Void) {
        var allComics: [BasicComic] = []
        var completedRequests = 0
        
        for page in 1...totalPages {
            fetchComics(forPage: page) { comics in
                completedRequests += 1
                allComics.append(contentsOf: comics)
                
                if completedRequests == totalPages {
                    completion(allComics)
                }
            }
        }
    }
}
