//
//  HomeController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit
import OSLog

// Tạo dữ liệu cho table view
var comicDatas:[ComicDataResponse] = []


class HomeController: UIViewController {
    
    
    

    // MARK: Properties
    @IBOutlet weak var bannerSlideCollectionView: UICollectionView!
    @IBOutlet weak var bannerSlidePageControl: UIPageControl!
    @IBOutlet weak var comicTableView: UITableView!
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
        
        
        // Xử lý gọi api lấy danh sách comics
        // Định nghĩa URL của API
        let urlString = "http://localhost:3000/manga"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Tạo một yêu cầu URL
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Hoặc "POST", "PUT", "DELETE"

        // Tạo một session và bắt đầu task
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            // Xử lý lỗi nếu có
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Kiểm tra phản hồi từ server
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            // Xử lý dữ liệu nhận được
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let comicApiResponse = try decoder.decode(ComicApiResponse.self, from: data)
                    if comicApiResponse.status == true && comicApiResponse.message == "success" {
                        comicDatas = (comicApiResponse.manga_list)
                       
                        DispatchQueue.main.async {
                            self.comicTableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                }
            }
        }

        // Bắt đầu task
        task.resume()
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
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDelegate, UITableViewDataSource {
    
    // Table view hiển thị danh sách truyện
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCardCell", for: indexPath) as! ComicLayoutTableViewCell
        cell.collectView.tag = indexPath.section
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return comicDatas[section].getComicType()
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comicDatas.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .black
    }
    
    
        
    // Collection view của banner
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
