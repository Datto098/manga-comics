//
//  ViewController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    // MARK: Properties
    @IBOutlet weak var comicColectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var comics = [ComicBasic]()
    let insetsSession = UIEdgeInsets(top: 20, left: 10, bottom: 50, right: 10)
    let itemsInRow : CGFloat = 2.0
    
    // MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        if let comic  = ComicBasic(title: "Doraemon", image: UIImage(named: "image-comic"), author: "Fuijio Fujiko") {
            comics.append(comic)
        }
        
        if let comic  = ComicBasic(title: "Doraemon", image: UIImage(named: "image-comic"), author: "Fuijio Fujiko") {
            comics.append(comic)
        }
        if let comic  = ComicBasic(title: "Doraemon", image: UIImage(named: "image-comic"), author: "Fuijio Fujiko") {
            comics.append(comic)
        }
        if let comic  = ComicBasic(title: "Doraemon", image: UIImage(named: "image-comic"), author: "Fuijio Fujiko") {
            comics.append(comic)
        }
        
        searchBar.delegate = self
        comicColectionView.delegate = self
        comicColectionView.dataSource = self
    }
    
    // MARK: UISearchBarDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            print("Searching for \(searchText)")
        }
                
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: UICollectionViewDelegateFlowLayout Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let resuleCell = "ComicCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuleCell, for: indexPath) as? ComicCell
        {
            let comic = comics[indexPath.row]
            //cell.backgroundColor = .brown
            cell.title.text = comic.title
            cell.image!.image = comic.image
            cell.author.text = comic.author

            return cell
        }
        // Lỗi nghiêm trọng => dùng fatalError
        fatalError("Không thể tạo Cell!")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpacing = (CGFloat(itemsInRow) + 1) * insetsSession.left
        
        let availabelWidth = view.frame.width - paddingSpacing
        let width = availabelWidth / itemsInRow
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        insetsSession
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        insetsSession.left
    }
}

