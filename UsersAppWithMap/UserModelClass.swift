//
//  UserModelClass.swift
//  UsersAppWithMap
//
//  Created by Clouds Mac1 on 29/01/22.
//

import Foundation

class UsersModelClass{
    var lattitude : String?
    var longitude : String?
    var gender:String?
    var name : String?
    var picture : String?
    var location : [String:Any]?
    init(data : [String:Any]){
        if let objName = data["name"] as? [String:Any]
        {
            name = "\(objName["title"] as! String) \(objName["first"] as! String) \(objName["last"] as! String)"
        }else
        {
            name = data["name"] as? String ?? ""
        }
        if let pictures = data["picture"] as? [String:Any]
        {
            picture = pictures["medium"] as? String ?? ""
            
        }else{
            picture = data["picture"] as? String ?? ""
        }
        location = data["location"] as? [String:Any] ?? [:]
        let coordinator = location!["coordinates"] as? [String:Any] ?? [:]
        lattitude = coordinator["latitude"] as? String ?? ""
        longitude = coordinator["longitude"] as? String ?? ""
        gender = data["gender"] as? String ?? ""
    }
    public func getlattitude()->String
    {
        return self.lattitude!
    }
    public func getlongitude()->String
    {
        return self.longitude!
    }
    public func getname()->String
    {
        return self.name!
    }
    public func getpicture()->String
    {
        return self.picture!
    }
    public func getlocation()->[String:Any]
    {
        return self.location!
    }
    public func getGender()->String
    {
        return self.gender!
    }
}
