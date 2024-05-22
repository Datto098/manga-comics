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
    private var comics:[String] = []
    
    // MARK: method
    init(comicType: String, comics: [String]) {
        self.comicType = comicType
        self.comics = comics
    }
    
    func getComicType() -> String {
        return self.comicType
    }
    
    func getComics() -> [String] {
        return self.comics
    }
    
    func setComicType(comicType:String) -> Void {
        self.comicType = comicType
    }
    
    func setComics(comics:[String]) -> Void {
        self.comics = comics
    }
}
