import UIKit
import Kingfisher

class ComicCell: UICollectionViewCell {

    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Set desired corner radius for rounded corners
        comicImageView.layer.cornerRadius = 20.0  // Adjust as needed

        // Add a shadow for a subtle lifting effect
        comicImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        comicImageView.layer.shadowOpacity = 0.3
        comicImageView.layer.shadowRadius = 4.0

        // Maintain aspect ratio using clipsToBounds
        comicImageView.clipsToBounds = true
    }

    func setData(with comic: ComicBasic) {
        comicTitleLabel.text = comic.title
        if let url = URL(string: comic.thumb) {
            comicImageView.kf.setImage(with: url)

            // Adjust frame to your desired size (replace with your dimensions)
            let desiredWidth = 170.0
            let desiredHeight = 225.0
            comicImageView.frame = CGRect(x: 0, y: 0, width: desiredWidth, height: desiredHeight)
        }
    }
    
}
