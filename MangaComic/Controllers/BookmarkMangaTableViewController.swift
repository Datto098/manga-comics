
import UIKit
import Kingfisher
import SkeletonView

class BookmarkMangaTableViewController: UITableViewController {

    @IBOutlet weak var navigation: UINavigationItem!
    private var bookmarkedMangas = [BasicComic]()
    private var dao:Database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dataUpdated(_:)), name: Notification.Name("dataUpdate"), object: nil)
        navigation.leftBarButtonItem = editButtonItem
        dao.getAllBookmark(bookmarks: &bookmarkedMangas)
    }
    
    @objc func dataUpdated(_ notification: Notification) {
            bookmarkedMangas.removeAll()
            dao.getAllBookmark(bookmarks: &bookmarkedMangas)
            tableView.reloadData()
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookmarkedMangas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MangaCell", for: indexPath) as! MangaCell

        // Configure the cell...
        let manga = bookmarkedMangas[indexPath.row]
        cell.title.text = manga.title
        cell.thumb.kf.setImage(with: URL(string: manga.thumb), placeholder: UIImage(named: "plaholder"))
        
        //Bo sung cho bat su kien theo cach 1
            if cell.onTap == nil {
                cell.onTap = UITapGestureRecognizer()
                //bat su kien
                cell.onTap!.addTarget(self, action: #selector(tapOnCell))
                cell.addGestureRecognizer(cell.onTap!)
            }
        return cell
    }
    
    @objc func  tapOnCell(sender:UITapGestureRecognizer){
        
        guard let cell = sender.view as? MangaCell else {
            return
        }
        
        let indexPath = tableView.indexPath(for: cell)
        let manga = bookmarkedMangas[indexPath!.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let navigationController = storyboard.instantiateViewController(withIdentifier: "navigationbarID") as? UINavigationController {
            
            let firstVC = navigationController.viewControllers.first as? DetailMangaViewController
            firstVC?.endPoint = manga.endpoint
            
            present(navigationController, animated: true, completion: nil)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
     */
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            //delete db
            let manga = bookmarkedMangas[indexPath.row]
            let _ = dao.deleteBookmark(endPoint: manga.endpoint)
            
            bookmarkedMangas.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
