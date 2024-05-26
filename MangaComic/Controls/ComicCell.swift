//
//  ComicCell.swift
//  MangaComic
//
//  Created by Chiendevj on 23/05/2024.
//
import UIKit
import Kingfisher

class ComicCell: UICollectionViewCell {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!
    @IBOutlet weak var comicType: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        // Add a shadow for a subtle lifting effect
//        comicImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        comicImageView.layer.shadowOpacity = 0.3
//        comicImageView.layer.shadowRadius = 4.0
//
//        // Maintain aspect ratio using clipsToBounds
//        comicImageView.clipsToBounds = true
//    }

    func setData(with comic: BasicComic) {
        comicType.text = comic.type
        comicTitleLabel.text = comic.title
        if let url = URL(string: comic.thumb) {
            comicImageView.kf.setImage(with: url)

            // Adjust frame to your desired size (replace with your dimensions)
            let desiredWidth = 170.0
            let desiredHeight = 125.0
            comicImageView.frame = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredHeight)
            
            // Apply rounded corners to the bottom edges
//            applyBottomRoundedCorners()
        }
    }
    
//    private func applyBottomRoundedCorners() {
//        let maskPath = UIBezierPath(roundedRect: comicImageView.bounds,
//                                    byRoundingCorners: [.bottomLeft, .bottomRight],
//                                    cornerRadii: CGSize(width: 20, height: 20))
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = maskPath.cgPath
//        comicImageView.layer.mask = maskLayer
//    }
}
