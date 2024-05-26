//
//  DetailController.swift
//  MangaComic
//
//  Created by Chiendevj on 24/05/2024.
//

import UIKit

class DetailController: UIViewController {

    public var detailComic : BasicComic?
   	
    @IBOutlet weak var titleDetail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let comic = detailComic {
            titleDetail.text = comic.title
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
