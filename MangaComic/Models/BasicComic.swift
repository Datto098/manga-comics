//
//  BasicComic.swift
//  MangaComic
//
//  Created by Chiendevj on 23/05/2024.
//
import Foundation

class BasicComic: Decodable {
    var title: String
    var thumb: String
    var type: String
    var endpoint : String

    init(title: String, thumb: String, type: String, endpoint: String) {
        self.title = title
        self.thumb = thumb
        self.type = type
        self.endpoint = endpoint
    }

    // Ánh xạ
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case thumb = "thumb"
        case type = "type"
        case endpoint = "endpoint"
    }
}

struct ComicResponse: Decodable {
    let manga_list: [BasicComic]
}
