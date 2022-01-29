//
//  SqliteClassForLocalStorage.swift
//  UsersAppWithMap
//
//  Created by Clouds Mac1 on 29/01/22.
//

import Foundation
import SQLite3

public class CreateDB{
    var db : OpaquePointer?
   var dbPath : URL?
    static let shared = CreateDB()
   public init() {
       print("In DB file")
   }
     func createDatabase(){
         let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
           dbPath = fileURL.appendingPathComponent("UsersDB")
     
         let manager = FileManager()
     if manager.fileExists(atPath: dbPath!.path){
             print("File exist")
         }else{
         manager.createFile(atPath: dbPath!.path, contents: nil, attributes: nil)
         }
         let UserTable = "CREATE TABLE IF NOT EXISTS UserTable(name TEXT PRIMARY KEY, gender TEXT, imageUrl TEXT)"
         var db : OpaquePointer?
         if sqlite3_open(dbPath!.path, &db) == SQLITE_OK{
             
             
             if sqlite3_exec(db, UserTable, nil, nil, nil) == SQLITE_OK{
                 print("table created successfully")
             }else{
                 let errmsg = String(cString: sqlite3_errmsg(db)!)
                 print("error in updating data in table: \(errmsg)")
                     print("Error in creating table")
             }
         }
     }
    
    func InserData(data:[[String:Any]])
    {
        for i in 0..<data.count
        {
            let nameObj = data[i]["name"] as? [String:Any] ?? [:]
            let name = "\(nameObj["title"] as! String) \(nameObj["first"] as! String) \(nameObj["last"] as! String)"
            let gender = data[i]["gender"] as? String ?? ""
            let imageObj = data[i]["picture"] as? [String:Any] ?? [:]
            let imageUrl = imageObj["medium"] as! String
            
            let insertUserData = String.init(format: "insert or ignore into UserTable values ('%@','%@','%@')", name, gender, imageUrl)
            
            let manager = FileManager()
            if manager.fileExists(atPath: dbPath!.path){
                print("File exist")
            }else{
                manager.createFile(atPath: dbPath!.path, contents: nil, attributes: nil)
            }
            var db1 : OpaquePointer?
            if sqlite3_open(dbPath!.path, &db1) == SQLITE_OK{
            if sqlite3_exec(db1, insertUserData.cString(using: .utf8), nil, nil, nil) == SQLITE_OK{
                print("Data inserted successfully")
            }else{
                let errmsg = String(cString: sqlite3_errmsg(db1)!)
                print("error in inserting data in table: \(errmsg)")
                print("Failed: in insertion of data")
            }
            }
        }
     }
    
    func FetchData(onSucess success : @escaping(_ Success : [[String:Any]]) -> Void){
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbPath = fileURL.appendingPathComponent("UsersDB")
        let manager = FileManager()
        if manager.fileExists(atPath: dbPath.path){
            print("File exists")
        }else{
            manager.createFile(atPath: dbPath.path, contents: nil, attributes: nil)
        }
        
        var db : OpaquePointer? = nil
        let status = sqlite3_open(dbPath.path, &db)
        if status == SQLITE_OK {
            let query = "SELECT * FROM UserTable"
            var dataObj = [[String:Any]]()
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare(db, query.cString(using: .utf8), -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW{
                    let name = String.init(format: "%s", sqlite3_column_text(stmt, 0))
                    let gender = String.init(format: "%s", sqlite3_column_text(stmt, 1))
                    let picture = String.init(format: "%s", sqlite3_column_text(stmt, 2))
                    let dic : [String:Any] = ["name" : name, "gender" : gender, "picture" : picture]
                    dataObj.append(dic)
                }
                success(dataObj)
            }
        }
    }
    
    func DeleteData()
    {
        let query = "Delete from UserTable"
         let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbPath1 = fileURL.appendingPathComponent("UsersDB")
            let manager = FileManager()
            if manager.fileExists(atPath: dbPath1.path){
                print("File exist")
            }else{
                manager.createFile(atPath: dbPath1.path, contents: nil, attributes: nil)
            }
            var db1 : OpaquePointer?
            if sqlite3_open(dbPath1.path, &db1) == SQLITE_OK{
                if sqlite3_exec(db1, query, nil, nil, nil) == SQLITE_OK{
                    print("Deleted successfully")
                }else{
                    let errmsg = String(cString: sqlite3_errmsg(db1)!)
                    print("error in deleting data in table: \(errmsg)")
                    print("not deleted")
                }
            }
            sqlite3_close(db1)
        }
}


