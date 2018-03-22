//
//  File.swift
//  OneStopClick
//
//  Created by Billy Christian on 26/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct Category{
    var id: Int
    var name: String
    
    /*
    init(dictionary:CategoryJson){
        self.id = dictionary["id"] as! Int
        self.name = dictionary["text"] as! String
    }
 */
    
    //should be deleted after the API fixed
    init(id:Int, name:String){
        self.id = id
        self.name = name
    }
}
