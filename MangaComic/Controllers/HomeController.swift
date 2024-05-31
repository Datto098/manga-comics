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
    var index = 0; // Dùng cho banner
    static var comicDatas:[ComicData] = [] // danh sách truyện theo thể loại
    static var mangaGenres:ComicGenresApiResponse? = nil // Các thể loại
    static var BASE_URL = "http://localhost:5000/manga"
    
    // Danh sách ảnh của Slider
    let bannerImages = ["image1", "image2", "image3", "image4", "image5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Thực hiện ủy quyền
        bannerSlideCollectionView.delegate = self
        bannerSlideCollectionView.dataSource = self			
        comicTableView.delegate = self
        comicTableView.dataSource = self
        
        // Cấu hình page control
        bannerSlidePageControl.numberOfPages = bannerImages.count
        bannerSlidePageControl.currentPage = 0
        
        // Xử lý tự động chạy slide sau mỗi 3s
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollingSetup), userInfo: nil, repeats: true)
        
        // Xử lý sự kiện khi chạm vào các page item của Page Control
        bannerSlidePageControl.addTarget(self, action: #selector(pageControlValueChange(_:)), for: .valueChanged)
        
        // Xử lý loading khi gọi api
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        
        // Hiển thị loading indicator
        loadingIndicator.startAnimating()
        
        
        // Xử lý gọi api lấy danh sách các thể loại
        // Alamofire thực hiện việc gọi API bất đồng bộ
        let urlGenres = "\(HomeController.BASE_URL)/genres"
        AF.request(urlGenres, method: .get).responseDecodable(of: ComicGenresApiResponse.self) { response in
            switch response.result {
            case .success(let comicGenres):
                print("commic genres: \(comicGenres)")
                if comicGenres.status == true && comicGenres.message == "success" {
                    HomeController.mangaGenres = comicGenres
                    
                    if let list = HomeController.mangaGenres?.list_genre {
                        let dispatchGroup = DispatchGroup() // Tạo DispatchGroup để quản lý các hành động bất đồng bộ
                        
                        
                        for item in list {
                            dispatchGroup.enter() // Thông báo một hành động mới được thực hiện (gọi api)
                            // Xử lý gọi api lấy danh sách comics theo thể loại
                            let urlStringPage = "\(HomeController.BASE_URL)/genre/\(self.convertGenreName(item.genre_name))"
                            self.fetchComicData(from: urlStringPage, comicType: item.genre_name) { comicData in
                                if let comicData = comicData {
                                    HomeController.comicDatas.append(comicData)
                                }
                                dispatchGroup.leave() // Thông báo hành động đã kết thúc
                            }
                        }
                        // Cập nhật lại table view
                        // Ẩn loading indicator sau khi tất cả các yêu cầu API kết thúc
                        dispatchGroup.notify(queue: .main) { // Gọi khi tất cả các hành động đã kết thúc
                            loadingIndicator.stopAnimating()
                            self.comicTableView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    
    // Hàm để gọi API và lấy dữ liệu commic về từ URL genres
    // Completion Handler
    func fetchComicData(from urlString: String, comicType: String, completion: @escaping (ComicData?) -> Void) {
        // Gọi API với địa chỉ URL được cung cấp
        AF.request(urlString, method: .get).responseDecodable(of: ComicDataByGenresApiResponse.self) { response in
            // Kiểm tra kết quả của cuộc gọi API
            switch response.result {
            case .success(let comicApiResponse):
                // Nếu cuộc gọi API thành công và trả về dữ liệu hợp lệ
                if comicApiResponse.status == true && comicApiResponse.message == "success" {
                    
                    let comicData = ComicData(comicType: comicType, comics: [comicApiResponse])
                    // Gọi closure completion với đối tượng ComicData được tạo
                    completion(comicData)
                } else {
                    // Nếu có lỗi trong dữ liệu trả về từ API, gọi closure completion với giá trị nil
                    completion(nil)
                }
            case .failure(let error):
                // Nếu có lỗi xảy ra trong quá trình gọi API, in ra thông báo lỗi
                print("Error: \(error.localizedDescription)")
                // Gọi closure completion với giá trị nil để xử lý lỗi
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
    
    // Hàm xử lý chuỗi genres
    func convertGenreName(_ genreName: String) -> String {
        let trimmedString = genreName.trimmingCharacters(in: .whitespaces)
        let lowercasedString = trimmedString.lowercased()
        let hyphenatedString = lowercasedString.replacingOccurrences(of: " ", with: "-")
        return hyphenatedString
    }
}


// MARK: - Table View
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    // Trả về số lượng hàng trong mỗi section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // để trả về số lượng section trong table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeController.comicDatas.count // Số lượng data comic nhận được
    }
    
    // Cấu hình cell bên trong table view
    // Cell => Collection View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComicCardCell", for: indexPath) as! ComicLayoutTableViewCell
        cell.collectView.tag = indexPath.section
        cell.collectView.reloadData()
        return cell
    }

    // Tạo header cho mỗi section
    // Header dùng để hiển thị thể loại truyện
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black // Background
        
        let headerLabel = UILabel()
        if HomeController.comicDatas.count > 0 {
            headerLabel.text = HomeController.comicDatas[section].getComicType() // Tiêu để của header
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
    
    // Chiều cao cho header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Chiều cao của header
    }
        
    
}

// MARK: Collection View Banner
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // Trả về số lượng item hình ảnh trong collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages.count
    }
    
    // Cấu hình cell, hiển thị hình ảnh tương ứng
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlideControllerCollectionViewCell", for: indexPath) as! SlideControllerCollectionViewCell
        cell.bannerImage.image = UIImage(named: bannerImages[indexPath.row])
        return cell
    }
    
    // Thêm ràng buộc kích thước
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Định kích thước cell bằng kích thước của collectionView
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Cập nhật page control khi người dùng cuộn qua các trang
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        // print("x: \(scrollView.contentOffset.x)") // Chiều ngang của của sổ
        // print("scrollView: \(scrollView.frame.size.width)") // Chiều ngang của một banner
        
        bannerSlidePageControl.currentPage = page
    }
}

