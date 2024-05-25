//
//  HomeController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit
import OSLog
import Alamofire

// Tạo dữ liệu cho table view



class HomeController: UIViewController {
    

    // MARK: Properties
    @IBOutlet weak var bannerSlideCollectionView: UICollectionView!
    @IBOutlet weak var bannerSlidePageControl: UIPageControl!
    @IBOutlet weak var comicTableView: UITableView!
    var index = 0;
    static var comicDatas:[ComicData] = []
    
    
    
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
        // Gọi API cho page 1
        let urlStringPage1 = "http://localhost:3000/manga/page/1"
        fetchComicData(from: urlStringPage1, comicType: "Manga") { comicData in
            if let comicData = comicData {
                HomeController.comicDatas.append(comicData)
                print("Call 1: \(HomeController.comicDatas.count)")
                DispatchQueue.main.async {
                    self.comicTableView.reloadData()
                }
            }
        }
        
        // Gọi API cho page 2
        let urlStringPage2 = "http://localhost:3000/manga/page/2"
        fetchComicData(from: urlStringPage2, comicType: "Manga 2") { comicData in
            if let comicData = comicData {
                HomeController.comicDatas.append(comicData)
                print("Call 2: \(HomeController.comicDatas.count)")
                DispatchQueue.main.async {
                    self.comicTableView.reloadData()
                }
            }
        }
    }
    
    // Hàm để gọi API
    func fetchComicData(from urlString: String, comicType:String ,completion: @escaping (ComicData?) -> Void) {
        AF.request(urlString, method: .get).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let comicApiResponse = try decoder.decode(ComicApiResponse.self, from: data)
                    if comicApiResponse.status == true && comicApiResponse.message == "success" {
                        let comicData = ComicData(comicType: comicType, comics: [comicApiResponse])
                        completion(comicData)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
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


// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HomeController.comicDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCardCell", for: indexPath) as! ComicLayoutTableViewCell
        cell.collectView.tag = indexPath.section
        return cell
    }

    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .black
    }
    
    
    // Style for header Collection View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        
        let headerLabel = UILabel()
        if HomeController.comicDatas.count > 0 {
            headerLabel.text = HomeController.comicDatas[section].getComicType()
        }
        headerLabel.textColor = .yellow // Đặt màu cho tiêu đề
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        // Sử dụng Auto Layout để thiết lập vị trí của headerLabel trong headerView
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Chiều cao của header
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
