//
//  MangaPage.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import UIKit
class MangaPage: Decodable {
    public let chapterImageLink: String
    public let imageNumber: Int

    //anh xa json key voi bien trong class
    enum CodingKeys: String, CodingKey {
        case chapterImageLink = "chapter_image_link"
        case imageNumber = "image_number"
    }
    
    //khoi tao
    init(chapterImageLink: String, imageNumber: Int) {
        self.chapterImageLink = chapterImageLink
        self.imageNumber = imageNumber
    }
}

