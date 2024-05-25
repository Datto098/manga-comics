//
//  MangaDetail.swift
//  MangaComic
//
//  Created by tandev on 24/5/24.
//

import UIKit
class MangaDetail : Decodable {
    //Properties
    public var title:String
    public var banner:String
    public var chapters:[Chapter]
    
    //anh xa json key voi bien trong class
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case banner = "thumb"
        case chapters = "chapter"
    }
    
    //init
    init(title: String, banner: String, chapters: [Chapter]) {
        self.title = title
        self.banner = banner
        self.chapters = chapters
    }
}
