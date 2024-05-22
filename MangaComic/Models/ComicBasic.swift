//
//  ComicBasic.swift
//  MangaComic
//
//  Created by Chiendevj on 21/05/2024.
//

import UIKit

class ComicBasic {
    let title : String
    let image : UIImage?
    let author : String
    
    init?(title: String, image: UIImage? = nil, author: String) {
        if title.isEmpty {
            return nil
        }
        if author.isEmpty {
            return nil
        }
        
        self.title = title
        self.image = image
        self.author = author
    }
}
