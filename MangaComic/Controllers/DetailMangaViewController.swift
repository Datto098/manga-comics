//
//  DetailMangaViewController.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import UIKit
import SkeletonView

class DetailMangaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    
    
    @IBOutlet weak var tableMangas: UITableView!
    @IBOutlet weak var banner:UIImageView!
    @IBOutlet weak var titleManga:UILabel!
    
    private var mangaDetail: MangaDetail?
    private var chapters = [Chapter]()
    var myControllers = [UIViewController]()
    var mangaPages = [MangaPage]()
    private var endPoint:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()

        MangaAPI.shared.getMangaDetail(endPoint: "one-piece"){
            mangaDetail in
            DispatchQueue.main.async {
                self.view.isSkeletonable = false
                self.view.hideSkeleton()
                self.mangaDetail = mangaDetail
                self.chapters = mangaDetail.chapters
                self.titleManga.text = mangaDetail.title
                self.banner.kf.setImage(with: URL(string: mangaDetail.banner))
                self.tableMangas.reloadData()
            }
        }
        tableMangas.dataSource = self
        tableMangas.delegate = self
       
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MangaChapterCell") as? MangaChapterCell else {
            return MangaChapterCell()
        }
        
        let chapter = chapters[indexPath.row]
        cell.titleChapter.text = chapter.title
        cell.puslishedChapter.text = chapter.date
        cell.mainImgChapter.kf.setImage(with: URL(string: chapter.image))
        
        // bat su kien khi click vao cell
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapChapter(_:))))

        return cell
        
    }
    
    // ham xu ly khi click vao cell
    @objc func tapChapter(_ sender: UITapGestureRecognizer){

        //get chapter
        guard let cell = sender.view as? MangaChapterCell else {
            return
        }
        
        let indexPath = tableMangas.indexPath(for: cell)
        let chapter = chapters[indexPath!.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pageReadMangaID") as! PageReadMangeController
        vc.chapter = chapter
        navigationController?.pushViewController(vc, animated: true)
    }
}

