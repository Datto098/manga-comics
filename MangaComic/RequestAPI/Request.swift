//
//  Request.swift
//  MangaComic
//
//  Created by Chiendevj on 23/05/2024.
//

import Alamofire

class BaseRequestService {
    
    // Hàm xử lý yêu cầu GET
    func getRequest<T: Decodable>(url: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
    
}

