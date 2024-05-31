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

    // Implement init(from decoder: Decoder) required by Decodable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.thumb = try container.decode(String.self, forKey: .thumb)
        self.type = try container.decode(String.self, forKey: .type)
        self.endpoint = try container.decode(String.self, forKey: .endpoint)
    }

    // CodingKeys enum to specify the keys used for decoding
    private enum CodingKeys: String, CodingKey {
        case title
        case thumb
        case type
        case endpoint
    }
}
struct ComicResponse: Decodable {
    let manga_list: [BasicComic]
}
