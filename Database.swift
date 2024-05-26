
import UIKit
import os.log // thu vien ham log
class Database {
    //MARK: Properties for db
    private let DB_NAME = "mangadb.sqlite"
    private var DB_PATH: String?
    private var database: FMDatabase?
    
    
    //MARK : Cac thuoc tinh lien quan den bang du lieu
    //1. Bang meals
    private let BOOKMARK_TABLE_NAME = "bookmarks"
    private let BOOKMARK_COLUMN_ID = "id"
    private let BOOKMARK_COLUMN_TITLE = "title"
    private let BOOKMARK_COLUMN_THUMB = "thumb"
    private let BOOKMARK_COLUMN_ENDPOINT = "endpoint"
    
    
    //MẢRK : Khởi tạo Database
    init() {
        // lay tat ca duong dan den cac thu muc doc trong ios
        let directories =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        
        DB_PATH = directories[0] + "/" + DB_NAME
        database = FMDatabase(path: DB_PATH)
        
        //kiem tra database
        if database == nil {
            os_log("Error: Khong the mo database", log: OSLog.default, type: .error)
        }
        else{
            os_log("Da mo database thanh cong", log: OSLog.default, type: .info)
            let sql = "CREATE TABLE IF NOT EXISTS \(BOOKMARK_TABLE_NAME) (\(BOOKMARK_COLUMN_ID) INTEGER PRIMARY KEY AUTOINCREMENT, \(BOOKMARK_COLUMN_TITLE) TEXT, \(BOOKMARK_COLUMN_THUMB) TEXT, \(BOOKMARK_COLUMN_ENDPOINT) TEXT)"
            
            let _ = createTable(sql: sql)
            
        }
        
    }
    
    
    //MARK : Cac ham thao tac voi database voi primitive data
    ///
    //1. Mo db
    private func openDB() -> Bool {
        var OK = false
        if database != nil {
            OK = database!.open()
        }
        return OK
    }
    
    //2. Close CSDL
    private func closeDB() {
        if database != nil {
            database!.close()
        }
    }
    
    //3. Ham tao bang chung
    private func createTable(sql:String) -> Bool{
        var OK = false
        if (openDB()){
            //thuc thi cau lenh sql
            OK = database!.executeStatements(sql)
            
        }
        return OK
    }
    
    
    
    
    
    //MARK: Cac ham api cua co so du lieu
    //1. Them moi 1 ban ghi
    func insert(comicBasic:ComicBasic)->Bool{
        var ok = false
        if openDB(){
            //kiem tra su ton tai cua bang
            if database!.tableExists("bookmarks"){
                let sql = "INSERT INTO \(BOOKMARK_TABLE_NAME) (\(BOOKMARK_COLUMN_TITLE), \(BOOKMARK_COLUMN_THUMB),\(BOOKMARK_COLUMN_ENDPOINT)) VALUES (?,?,?)"
              
                ok = database!.executeUpdate(sql, withArgumentsIn: [comicBasic.title,comicBasic.thumb,comicBasic.endpoint])
                
            }
            closeDB()
        }
        
        return ok;
    }
    
    
    //2. Lay tat ca ban ghi
    func getAllBookmark(bookmarks: inout [ComicBasic]){
        if openDB(){
            let sql = "SELECT * FROM \(BOOKMARK_TABLE_NAME) ORDER BY \(BOOKMARK_COLUMN_ID) ASC"

            var results:FMResultSet?
            do {
                results = try database!.executeQuery(sql, values: nil)
            }catch{
                os_log("Error: Khong the lay du lieu", log: OSLog.default, type: .error)
            }
            while results!.next() {
                os_log("\(results!.string(forColumn: self.BOOKMARK_COLUMN_TITLE)!)")
                
                let title = results!.string(forColumn: BOOKMARK_COLUMN_TITLE)!
                let thumb = results!.string(forColumn: BOOKMARK_COLUMN_THUMB)!
                let endpoint = results!.string(forColumn: BOOKMARK_COLUMN_ENDPOINT)!
                
                let comicBasic = ComicBasic(title: title, thumb: thumb,endpoint: endpoint)
                bookmarks.append(comicBasic)
            }
            closeDB()
        }
    }
    
    //check comicBasic is bookmarked
    func isBookmarked(endPoint:String)->Bool{
        var ok = false
        if openDB(){
            let sql = "SELECT * FROM \(BOOKMARK_TABLE_NAME) WHERE \(BOOKMARK_COLUMN_ENDPOINT) = ?"
            
            do {
                let results = try database!.executeQuery(sql, values: [endPoint])
                while results.next() {
                    ok = true
                    break
                }
            }catch{
                os_log("Error: Khong the lay du lieu", log: OSLog.default, type: .error)
            }
            
           
            closeDB()
        }
        return ok
    }
    
    //delete bôokmark
    func deleteBookmark(endPoint:String)->Bool{
        var ok = false
        if openDB(){
            let sql = "DELETE FROM \(BOOKMARK_TABLE_NAME) WHERE \(BOOKMARK_COLUMN_ENDPOINT) = ?"
            ok = database!.executeUpdate(sql, withArgumentsIn: [endPoint])
            closeDB()
        }
        os_log("\(ok)")
        return ok
    }
    
}
