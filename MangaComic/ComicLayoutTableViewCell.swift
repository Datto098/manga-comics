//
//  ComicLayoutTableViewCell.swift
//  MangaComic
//
//  Created by dattodev on 22/05/2024.
//

import UIKit
import AppTrackingTransparency

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
        return comicDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardItemCell", for: indexPath) as! ComicLayoutCollectionViewCell
        
        if let url = URL(string: comicDatas[collectionView.tag].thumb) {
            cell.comicImage.kf = UIImage(data: image)
        }
       

        return cell
    }
}
