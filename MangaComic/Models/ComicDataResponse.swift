//
//  ComicDataResponse.swift
//  MangaComic
//
//  Created by dattodev on 22/05/2024.
//

import Foundation

class ComicDataResponse:Codable {
    var title:String = ""
    var thumb:String = ""
    var type:String = ""
    var updated_on:String = ""
    var endpoint:String = ""
    var chapter:String = ""
    var chapter_endpoint:String = ""
}
