//
//  MangaCell.swift
//  MangaComic
//
//  Created by tandev on 24/5/24.
//

import UIKit

class MangaCell: UITableViewCell {
    
    @IBOutlet weak var thumb: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var onTap:UITapGestureRecognizer?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        //thuc hien uy quyen
        if onTap != nil {
            onTap?.delegate = self
        }
        
    }
    
    //Dinh nghia ham uy quyen choi doi tuong gesture reconigerz
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view == self.contentView)
    }

}
