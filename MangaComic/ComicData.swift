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
    private var comics:[ComicApiResponse] = []
    
    // MARK: method
    init(comicType: String, comics: [ComicApiResponse]) {
        self.comicType = comicType
        self.comics = comics
    }
    
    func getComicType() -> String {
        return self.comicType
    }
    
    func getComics() -> [ComicApiResponse] {
        return self.comics
    }
    
    func setComicType(comicType:String) -> Void {
        self.comicType = comicType
    }
    
    func setComics(comics:[ComicApiResponse]) -> Void {
        self.comics = comics
    }
}
