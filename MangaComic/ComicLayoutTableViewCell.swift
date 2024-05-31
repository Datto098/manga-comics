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
        cell.comicDescription.text = HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].chapter
        
        // Image
        if let url = URL(string: HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].thumb) {
            cell.comicImage.kf.setImage(with: url)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailController = parentViewController?.storyboard?.instantiateViewController(withIdentifier: "detailMangaID") as? DetailMangaViewController {
            let endpoint = HomeController.comicDatas[collectionView.tag].getComics()[0].manga_list[indexPath.row].endpoint.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "manga/").last!
            print("Chuỗi đã xử lý \(endpoint)")
            detailController.endPoint = endpoint
            let navigationController = UINavigationController(rootViewController: detailController)
            navigationController.modalPresentationStyle = .fullScreen
            parentViewController?.present(navigationController, animated: true)
        }
    }
}

// Extension để lấy view controller cha của UITableViewCell
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while let nextResponder = parentResponder?.next {
            parentResponder = nextResponder
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
