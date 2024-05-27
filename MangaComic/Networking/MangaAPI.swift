//  MangaAPI.swift
import Alamofire
import os

class MangaAPI {
    
    //design pattern: Singleton
    static let shared = MangaAPI()
    
    // function get list infor in one chapter
    func getPagesMangaWithNumberChapter(endPoint: String, completion: @escaping ([MangaPage]) -> Void) {
        let url = "http://localhost:5000/manga/chapter/\(endPoint)" // Thay bằng URL API thực tế
        AF.request(url).responseDecodable(of: ChapterResponse.self) { response in
            switch response.result {
            case .success(let chapterResponse):
                let mangaPages = chapterResponse.chapterImage.map { chapterImage in
                    return MangaPage(chapterImageLink: chapterImage.chapterImageLink, imageNumber: chapterImage.imageNumber)
                }
                completion(mangaPages) // Gọi completion handler với mảng MangaPage
            case .failure(let error):
                print("Error: \(error)")
                completion([]) // Gọi completion handler với mảng rỗng trong trường hợp lỗi
            }
        }
    }
    
    //function get manga detail
    func getMangaDetail(endPoint: String, completion: @escaping (MangaDetail) -> Void) {
        let url = "http://localhost:5000/manga/detail/\(endPoint)" // Thay bằng URL API thực tế
        AF.request(url).responseDecodable(of: MangaDetail.self) { response in
            switch response.result {
            case .success(let mangaDetail):
                completion(mangaDetail) // Gọi completion handler với đối tượng MangaDetail
            case .failure(let error):
                print("Error: \(error)")
                completion(MangaDetail(title: "", banner: "", chapters: [])) // Gọi completion handler với đối tượng MangaDetail rỗng trong trường hợp lỗi
            }
        }
    }
}

