//
//  ComicGenresApiResponse.swift
//  MangaComic
//
//  Created by dattodev on 25/05/2024.
//

import Foundation

class ComicGenresApiResponse:Codable {
    var status:Bool = false
    var message:String = ""
    var list_genre:[ComicGenres] = []
}
