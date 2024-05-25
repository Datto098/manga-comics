//
//  Chapter.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import UIKit
class Chapter : Decodable{
    //Properties
    public var title:String
    public var endpoint:String
    public var image:String
    public var date:String
    
    //anh xa json key voi bien trong class
    enum CodingKeys: String, CodingKey {
        case title = "chapter_title"
        case endpoint = "chapter_endpoint"
        case date = "chapter_date"
        case image = "chapter_image"
    }
    
    //init
    init(title: String, endpoint: String, date: String, image: String) {
        self.title = title
        self.endpoint = endpoint
        self.date = date
        self.image = image
    }
}
