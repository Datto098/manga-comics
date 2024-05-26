//
//  SearchController.swift
//  MangaComic
//
//  Created by Chiendevj on 21/05/2024.
//

import UIKit

class SearchController:UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
     
    // MARK: Properties
    
    @IBOutlet weak var comicCollectionView: UICollectionView!

    @IBOutlet weak var searchBar: UISearchBar!
    // MARK: Variable
    var comics = [BasicComic]()
    var filteredComics = [BasicComic]()
    private let comicDetailStoryboardID = "ComicDetail"
    var isSearching = false
    var estimateWidth = 180.0
    var estimateHeight = 270.0
    var spacing = 20.0
    let comicService = ComicService()
    
    // MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate and dataSource
        self.comicCollectionView.dataSource = self
        self.comicCollectionView.delegate = self
        
        fetchComics()
        self.setUpGridView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpGridView()
        DispatchQueue.main.async {
            self.comicCollectionView.reloadData()
        }
    }

    func setUpGridView() {
            let layout = comicCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
            layout.minimumInteritemSpacing = CGFloat(spacing)
            layout.minimumLineSpacing = CGFloat(spacing)
        }

    
    func fetchComics() {
        ComicService.shared.fetchMultiplePages(totalPages: 26) { result in
            switch result {
            case .success(let comics):
                print("Fetched \(comics.count) comics.")
                // Do something with the comics
                self.comics = comics
                self.filteredComics = comics
                DispatchQueue.main.async {
                    self.comicCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch comics: \(error)")
            }
        }

    }

    // MARK: UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredComics = comics
        } else {
            isSearching = true
            filteredComics = comics.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        comicCollectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredComics = comics
        comicCollectionView.reloadData()
    }

    // MARK: UICollectionViewDelegateFlowLayout Methods & UICollectionViewDataResource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredComics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCell", for: indexPath) as? ComicCell {
            let comic = filteredComics[indexPath.row]
            cell.setData(with: comic)
    
            return cell
        }
        
        // Lỗi nghiêm trọng => dùng fatalError
        fatalError("Don't create a cell!")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("click")
        if let detailController = self.storyboard!.instantiateViewController(withIdentifier: comicDetailStoryboardID) as? DetailController {
            
            detailController.detailComic = filteredComics[indexPath.row]
        
            // Hiển thị màn hình MealDetailController
            present(detailController, animated: true)
           
        }
    }

}
