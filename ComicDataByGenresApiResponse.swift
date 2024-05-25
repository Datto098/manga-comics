//
//  ComicDataByGenresApiResponse.swift
//  MangaComic
//
//  Created by dattodev on 25/05/2024.
//

import Foundation

class ComicDataByGenresApiResponse:Codable {
    var status:Bool = false
    var message:String = ""
    var manga_list:[ComicDataByGenres] = []
}
