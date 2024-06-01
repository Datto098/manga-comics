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
    var currentImageId = 0;
    

    //init
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()
        view.backgroundColor = .black
        //set title
        self.title = chapter.title
        self.dataSource = self
        self.delegate = self
       
        
        let endPoint = chapter.endpoint.split(separator: "/").last?.trimmingCharacters(in: .whitespacesAndNewlines)
        //print("endPoint: \(String(describing: endPoint))")
        //endPoint = "one-piece-chapter-00"

        MangaAPI.getPagesMangaWithNumberChapter(endPoint: endPoint!) { pages in
            self.mangaPages = pages
            // Cập nhật UI trên main thread (DispatchQueue.main.async)
            if pages.count == 0{
                let alertController = UIAlertController(
                    title: "Thông báo",
                    message: "Truyện đang được cập nhật.",
                    preferredStyle: .alert // Hoặc .actionSheet cho kiểu khác
                )

                let cancelAction = UIAlertAction(title: "Hủy", style: .cancel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(cancelAction)

                // Hiển thị dialog
                self.present(alertController, animated: true, completion: nil)
            }
            else{
                for page in self.mangaPages {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: URL(string: page.chapterImageLink),placeholder: UIImage(named: "commic-ic"))
                    // os_log("Image link: %@", page.chapterImageLink)
                    
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
                    if let first = self.myControllers.first {
                        self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
                    }
                }
            }
            
            
        }
    }
    // Lưu chapter
    func saveChaptersToJSON(chapters: [[String: Any]]) {
        // Đường dẫn tới thư mục Documents của ứng dụng
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return }

        // Đường dẫn tới file JSON
        let fileURL = documentDirectory.appendingPathComponent("chapters.json")

        do {
            // Chuyển đổi dữ liệu thành JSON
            let jsonData = try JSONSerialization.data(withJSONObject: chapters, options: .prettyPrinted)
            
            // Ghi dữ liệu vào file
            try jsonData.write(to: fileURL)
            print("Dữ liệu đã được lưu vào file JSON")
        } catch {
            print("Lỗi khi lưu dữ liệu: \(error.localizedDescription)")
        }
    }
    
    // Đọc dữ liệu chapter đã lưu
    func loadChaptersFromJSON() -> [[String: Any]]? {
        // Đường dẫn tới thư mục Documents của ứng dụng
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return nil }

        // Đường dẫn tới file JSON
        let fileURL = documentDirectory.appendingPathComponent("chapters.json")

        do {
            // Đọc dữ liệu từ file
            let data = try Data(contentsOf: fileURL)
            
            // Chuyển đổi dữ liệu từ JSON thành mảng các dictionary
            if let chapters = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return chapters
            }
        } catch {
            print("Lỗi khi đọc dữ liệu: \(error.localizedDescription)")
        }
        return nil
    }
    
    // Tra ve vỉew controller truoc do
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Kiem tra xem view controller hien tai co trong myControllers khong
        guard let index = myControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        
        let before = index - 1
        
        print("before: \(before)")
        
        // Cập nhật image id vào mảng chapterSave
        updateChapterSave(chapterIndex: before)
        
        return myControllers[before]
    }

    // Tra ve view controller sau do
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = myControllers.lastIndex(of: viewController), index < (myControllers.count - 1) else {
            return nil
        }
        
        let after = index + 1
        
        print("after: \(after)")
        
        // Cập nhật image id vào mảng chapterSave
        updateChapterSave(chapterIndex: after)
        
        return myControllers[after]
    }
    
    // Cập nhật image id vào mảng chapterSave
    func updateChapterSave(chapterIndex: Int) {
        var found = false
        for i in 0..<DetailMangaViewController.chapterSave.count {
            var chap = DetailMangaViewController.chapterSave[i]
            if let title = chap["title"] as? String, let id = chap["id"] as? String {
                if title == chapter.title && id == chapter.endpoint {
                    // Cập nhật image id
                    chap["image"] = chapterIndex
                    DetailMangaViewController.chapterSave[i] = chap
                    found = true
                    break
                }
            }
        }
        if !found {
            DetailMangaViewController.chapterSave.append(["title": chapter.title, "id": chapter.endpoint, "image": chapterIndex])
        }
        
        
        for i in 0..<DetailMangaViewController.chapterSave.count {
            let chap = DetailMangaViewController.chapterSave[i]
            if let title = chap["title"] as? String, let id = chap["id"] as? String, let image = chap["image"] {
                print("Title: \(title), id: \(id), Image: \(image)")
            }
        }
        // Lưu mảng chapterSave vào file JSON
        saveChaptersToJSON(chapters: DetailMangaViewController.chapterSave)
    }
}
