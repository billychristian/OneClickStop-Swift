//
//  Review.swift
//  OneStopClick
//
//  Created by Billy Christian on 09/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

class Review : NSObject{
    var id : Int
    var reviewDescription : String
    var createdAt : Date
    var updatedAt : Date
    var user : User
    
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as! Int
        self.reviewDescription = dictionary["description"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        
        self.createdAt = dateFormatter.date(from: dictionary["created_at"] as! String)!
        self.updatedAt = dateFormatter.date(from: dictionary["updated_at"] as! String)!
        
        self.user = User.init(dictionary: dictionary["user"] as! [String:Any])
    }
}
