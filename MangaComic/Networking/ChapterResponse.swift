//
//  ChapterResponse.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

class ChapterResponse: Decodable {
    public let chapterImage: [MangaPage]

    enum CodingKeys: String, CodingKey {
        case chapterImage = "chapter_image"
    }
}
