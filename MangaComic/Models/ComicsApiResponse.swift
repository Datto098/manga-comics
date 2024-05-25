//
//  ComicsApiResponse.swift
//  MangaComic
//
//  Created by dattodev on 22/05/2024.
//

import Foundation

class ComicApiResponse:Codable {
    var status:Bool = false
    var message:String = ""
    var next:String = ""
    var prev:String = ""
    var manga_list: [ComicDataResponse] = []
}
