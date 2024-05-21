//
//  ViewController.swift
//  MangaComic
//
//  Created by dattodev on 21/05/2024.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        searchBar.delegate = self
        
    }
    
    func configureUI() {
            view.backgroundColor = .white
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.title = "Search Comics"
            navigationController?.navigationBar.tintColor = .black
        }
    
    // MARK: UISearchBarDelegate Methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
                print("Searching for \(searchText)")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
                searchBar.resignFirstResponder()
    }

}

