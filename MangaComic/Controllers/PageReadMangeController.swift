//
//  PageReadMangeController.swift
//  MangaComic
//
//  Created by tandev on 22/5/24.
//

import UIKit
import Kingfisher
import os.log

class PageReadMangeController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
   
    var chapter:Chapter!
    private var myControllers = [UIViewController]()
    private var mangaPages = [MangaPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()
        view.backgroundColor = .black
        //set title
        self.title = chapter.title
        
        self.dataSource = self
        self.delegate = self
        
        var endPoint = chapter.endpoint.split(separator: "/").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        //endPoint = "one-piece-chapter-00"

        MangaAPI.shared.getPagesMangaWithNumberChapter(endPoint: endPoint!) { pages in
            self.mangaPages = pages
            // Cập nhật UI trên main thread (DispatchQueue.main.async)
            for page in self.mangaPages {
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: page.chapterImageLink),placeholder: UIImage(named: "placeholder"))
                os_log("Image link: %@", page.chapterImageLink)
                
                //set imageview possision X = 50
                imageView.frame = CGRect(x: 0, y: 100, width: vc.view.frame.width - 100, height: (vc.view.frame.height - 200))
                //center imageview
                imageView.center = vc.view.center
                
                imageView.contentMode = .scaleAspectFit
                vc.view.addSubview(imageView)
                self.myControllers.append(vc)
                
            }
           
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.view.isSkeletonable = false
                self.view.hideSkeleton()
                guard let first = self.myControllers.first else {
                    return
                }
                self.setViewControllers([first],direction: .forward, animated: true, completion: nil)
            }
            
        }
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
