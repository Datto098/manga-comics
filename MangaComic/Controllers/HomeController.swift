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
    var index = 0;
    
    // Danh sách ảnh của Slider
    let bannerImages = ["image1", "image2", "image3", "image4", "image5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        bannerSlideCollectionView.delegate = self
        bannerSlideCollectionView.dataSource = self
                
        // Cấu hình page control
        bannerSlidePageControl.numberOfPages = bannerImages.count
        bannerSlidePageControl.currentPage = 0
        
        // Xử lý tự động chạy slide sau mỗi 3s
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollingSetup), userInfo: nil, repeats: true)
        
        // Xử lý sự kiện khi chạm vào các page item của Page Control
        bannerSlidePageControl.addTarget(self, action: #selector(pageControlValueChange(_:)), for: .valueChanged)
    }
    
    // Hàm xử lý thay đổi giá trị của page control
    @objc func pageControlValueChange(_ sender: UIPageControl) {
        // Cập nhật lại vị trí index của slide
        index = sender.currentPage
        
        // Thực hiện cập nhật lại slide
        bannerSlidePageControl.currentPage = index
        bannerSlideCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
    }
    
    // Hàm xử lý scrolling
    @objc func scrollingSetup() {
        if index < bannerImages.count - 1 {
            index = index + 1
        }else {
            index = 0
        }
        
        // Thực hiện cập nhật lại slide
        bannerSlidePageControl.currentPage = index
        bannerSlideCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .right, animated: true)
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
