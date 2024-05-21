//
//  HomeController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit

class HomeController: UIViewController {

    @IBOutlet weak var bannerSlideCollectionView: UICollectionView!
    @IBOutlet weak var bannerSlidePageControl: UIPageControl!
    
    // Danh sách ảnh của Slider
    let bannerImages = ["image1", "image2", "image3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bannerSlideCollectionView.delegate = self
        bannerSlideCollectionView.dataSource = self
                
        // Cấu hình page control
        bannerSlidePageControl.numberOfPages = bannerImages.count
        bannerSlidePageControl.currentPage = 0
    }
}

// Mở rộng lớp HomeController
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideControllerCollectionViewCell", for: indexPath) as! SlideControllerCollectionViewCell
        cell.bannerImage.image = UIImage(named: bannerImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Định kích thước cell bằng kích thước của collectionView
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Cập nhật page control khi người dùng cuộn qua các trang
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        bannerSlidePageControl.currentPage = page
    }
}
