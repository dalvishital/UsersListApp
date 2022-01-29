//
//  ApiClass.swift
//  UsersAppWithMap
//
//  Created by Clouds Mac1 on 29/01/22.
//

import Foundation

var users = [UsersModelClass]()
class ApiUserClass{
    static let shared = ApiUserClass()
    func FetchData(onSucess success : @escaping(_ Success : Bool) -> Void, onFailure failure : @escaping(_ failed : Error)-> Void){
        let url = URL(string: "https://randomuser.me/api/?results=1000")!
        let session = URLSession.shared
         let dataTask = session.dataTask(with: url) { (data, response, error) in
             if error == nil{
                 let httpRes = response as! HTTPURLResponse
                 if httpRes.statusCode == 200
                 {
                     do{
                         let json = try JSONSerialization.jsonObject(with: data!, options: [.fragmentsAllowed]) as? [String:AnyObject]
                         if json != nil
                         {
                             
                             let dataObject = json!["results"] as? [[String:Any]] ?? [[:]]
                             print("Getting data",dataObject)
                             users.removeAll()
                             CreateDB.shared.DeleteData()
                             userFlag = true
                             CreateDB.shared.InserData(data: dataObject)
                             for i in 0..<dataObject.count
                             {
                                 let Object = UsersModelClass(data: dataObject[i])
                                 users.append(Object)
                             }
                             
                             success(true)
                          }
                     }catch{
                         print("erroMsg",error)
                         failure(error)
                     }
                 }
             }
         }
         dataTask.resume()
    }
}
