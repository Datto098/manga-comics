//
//  ViewController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit
import Alamofire
import Kingfisher

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    var myControllers = [UIViewController]()
    var mangaPages = [MangaPage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        MangaAPI.shared.getPagesMangaWithNumberChapter(endPoint: "martial-peak-chapter-3") { pages in
            self.mangaPages = pages
           
            // Cập nhật UI trên main thread (DispatchQueue.main.async)
            for page in self.mangaPages {
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: page.chapterImageLink),placeholder: UIImage(named: "placeholder"))
                imageView.frame = vc.view.frame
                imageView.contentMode = .scaleAspectFit
                vc.view.addSubview(imageView)
                self.myControllers.append(vc)
            }
            
        }

       
    }
    
    // Khi view controller hien thi
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.presentPageVc()
        }
    }
    
    // Hien thi page view controller
    func presentPageVc(){
        
        // Kiem tra xem myControllers co view controller nao khong
        guard let first = myControllers.first else {
            return
        }
        
        let vc = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal,options: nil)
        
        // Set the data source for the page view controller
        vc.dataSource = self
        // set delegate for the page view controller
        vc.delegate = self
        
        
        //Goi ham setViewControllers de hien thi trang dau tien
        vc.setViewControllers([first],direction: .forward, animated: true, completion: nil)
        present(vc, animated: true, completion: nil)
    }



    // Tra ve vỉew controller truoc do
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Kiem tra xem view controller hien tai co trong myControllers khong
        
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        
        let before = index - 1
        return myControllers[before]
    }
    
    // Tra ve view controller sau do
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = myControllers.lastIndex(of: viewController), index < (myControllers.count - 1) else {
            return nil
        }
        
        let after = index + 1
        return myControllers[after]
    }
}