//
//  MangaChapterCell.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import UIKit

class MangaChapterCell: UITableViewCell {

    @IBOutlet weak var mainImgChapter:UIImageView!
    @IBOutlet weak var titleChapter:UILabel!
    @IBOutlet weak var puslishedChapter:UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
      
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //set padding cho cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set the width of the cell
        let padding: CGFloat = 10
        
        // Set the width of the cell
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
    }
   
    
    

}
