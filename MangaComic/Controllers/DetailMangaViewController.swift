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
    static var chapterSave: [[String: Any]] = []
    public var endPoint:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.isSkeletonable = true
        view.showAnimatedGradientSkeleton()

        MangaAPI.shared.getMangaDetail(endPoint: endPoint!){
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

        // Đọc danh sách chapter đã lưu
        // Đường dẫn tới thư mục Documents của ứng dụng
        if let loadedChapters = loadChaptersFromJSON() {
            DetailMangaViewController.chapterSave = loadedChapters
        } else {
            DetailMangaViewController.chapterSave = []
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
    
    @objc func tapChapter(_ sender: UITapGestureRecognizer) {
        // get chapter
        guard let cell = sender.view as? MangaChapterCell else {
            return
        }
        
        guard let indexPath = tableMangas.indexPath(for: cell) else { return }
        let chapter = chapters[indexPath.row]
        var currentChapterImage = 0
        var saveMore = true
        
        // Kiểm tra chapter đã lưu hay chưa khi người dùng đọc
        if DetailMangaViewController.chapterSave.count > 0 {
            for chap in DetailMangaViewController.chapterSave {
                if let title = chap["title"] as? String, let id = chap["id"] as? String, let image = chap["image"] as? Int {
            
                    if title == chapter.title && id == chapter.endpoint {
                        // Lấy dữ liệu chapter đã lưu
                        currentChapterImage = image
                        saveMore = false
                        break
                    }
                }
            }
            
            if saveMore {
                DetailMangaViewController.chapterSave.append(["title": chapter.title, "id": chapter.endpoint, "image": 0])
                saveChaptersToJSON(chapters: DetailMangaViewController.chapterSave)
            }
        } else {
            DetailMangaViewController.chapterSave.append(["title": chapter.title, "id": chapter.endpoint, "image": 0])
            saveChaptersToJSON(chapters: DetailMangaViewController.chapterSave)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pageReadMangaID") as! PageReadMangeController
        vc.chapter = chapter
        vc.currentImageId = currentChapterImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

