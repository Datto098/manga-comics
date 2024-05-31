//
//  SearchController.swift
//  MangaComic
//
//  Created by Chiendevj on 23/05/2024.
//
import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    // MARK: Properties
    
    @IBOutlet weak var comicCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var comics = [BasicComic]()
    private var filteredComics = [BasicComic]()
    private let comicDetailStoryboardID = "detailMangaID"
    private var spacing = 10.0
//    private let comicService = ComicService()
    private let numberPage = 10
    
    // MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and dataSource
        self.comicCollectionView.dataSource = self
        self.comicCollectionView.delegate = self
        
        fetchComics()
        self.setUpView()
    }

    func setUpView() {
        let layout = comicCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.minimumLineSpacing = CGFloat(spacing)
    }
    
    func fetchComics() {
        ComicService.shared.fetchMultiplePages(totalPages: numberPage) { comics in
            print("Fetched \(comics.count) comics.")
            self.comics = comics
            self.filteredComics = comics
            DispatchQueue.main.async {
                self.comicCollectionView.reloadData()
            }
        }
    }

    // MARK: UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredComics = comics
        } else {
            filteredComics = comics.filter { comic in comic.title.lowercased().contains(searchText.lowercased()) }
        }
      
        comicCollectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredComics = comics
         
        comicCollectionView.reloadData()
    }

    // MARK: UICollectionViewDelegateFlowLayout Methods & UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as? ComicCell {
            let comic = filteredComics[indexPath.row]
            cell.setData(with: comic)
    
            return cell
        }
        
        fatalError("Don't create a cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailController = self.storyboard?.instantiateViewController(withIdentifier: comicDetailStoryboardID) as? DetailMangaViewController {
            let endpoint = filteredComics[indexPath.row].endpoint.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "manga/").last!
            print("Chuỗi đã xử lý \(endpoint)")
            detailController.endPoint = endpoint
            let navigationController = UINavigationController(rootViewController: detailController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
}
