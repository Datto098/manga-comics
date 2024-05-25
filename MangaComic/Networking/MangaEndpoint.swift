//
//  MangaEndpoint.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import Foundation
enum MangaEndpoint {
    case list
    var url: URL {
        switch self {
        case .list:
            return URL(string: "https://your_api_base_url/manga/list")!
        }
    }
}
