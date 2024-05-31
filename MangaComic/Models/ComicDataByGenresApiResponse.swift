//
//  ComicDataByGenresApiResponse.swift
//  MangaComic
//
//  Created by dattodev on 25/05/2024.
//

import Foundation

class ComicDataByGenresApiResponse:Codable {
    var status: Bool
    var message: String?
    var genre_title: String?
    var count_data: String?
    var manga_list: [ComicDataByGenres]

    enum CodingKeys: String, CodingKey {
           case status
           case message
           case genre_title = "genre_title"
           case count_data = "count_data"
           case manga_list = "manga_list"
    }
}
