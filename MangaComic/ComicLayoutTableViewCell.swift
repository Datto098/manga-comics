//
//  ComicLayoutTableViewCell.swift
//  MangaComic
//
//  Created by dattodev on 22/05/2024.
//

import UIKit
import AppTrackingTransparency
import Kingfisher

class ComicLayoutTableViewCell: UITableViewCell {

    // MARK: properties
    
    @IBOutlet weak var collectView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectView.delegate = self
        collectView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// Mở rộng lớp
extension ComicLayoutTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeController.comicDatas[section].getComics()[0].manga_list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardItemCell", for: indexPath) as! ComicLayoutCollectionViewCell
        
        
        // Title
        cell.comicTitle.text = HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].title
        
        // Updated at
        cell.comicDescription.text = HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].updated_on
        
        // Image
        if let url = URL(string: HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].thumb) {
            cell.comicImage.kf.setImage(with: url)
        }
       
        return cell
    }

}
