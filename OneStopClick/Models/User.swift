//
//  User.swift
//  OneStopClick
//
//  Created by Billy Christian on 09/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

class User : NSObject{
    var id : Int?
    var tokenId : String?
    var name : String
    var email : String
    var createdAt : Date?
    var updatedAt : Date?
    var imageUrl : URL?
    
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as? Int
        self.name = dictionary["name"] as! String
        self.email = dictionary["email"] as! String
    }
    
    init(tokenId:String, fullName: String, email:String, imageUrl : URL?){
        self.tokenId = tokenId
        self.name = fullName
        self.email = email
        self.imageUrl = imageUrl
    }
}
