//
//  ComicData.swift
//  MangaComic
//
//  Created by dattodev on 22/05/2024.
//

import Foundation

class ComicData {
    // MARK: properties
    private var comicType:String = ""
    private var comics:[ComicDataByGenresApiResponse] = []
    
    // MARK: method
    init(comicType: String, comics: [ComicDataByGenresApiResponse]) {
        self.comicType = comicType
        self.comics = comics
    }
    
    func getComicType() -> String {
        return self.comicType
    }
    
    func getComics() -> [ComicDataByGenresApiResponse] {
        return self.comics
    }
    
    func setComicType(comicType:String) -> Void {
        self.comicType = comicType
    }
    
    func setComics(comics:[ComicDataByGenresApiResponse]) -> Void {
        self.comics = comics
    }
    
    func logInfo() {
        print("Type: \(comicType), comics: \(comics[0].manga_list.count)")
    }
}
