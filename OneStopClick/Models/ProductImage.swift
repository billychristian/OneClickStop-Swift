//
//  ProductImage.swift
//  OneStopClick
//
//  Created by Billy Christian on 02/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

class ProductImage: NSObject{
    var id: Int
    var productId : Int
    var imageTypeId : Int
    var image : String
    var imageUrl : String
    
    init(dictionary:[String:Any]){
        self.id = dictionary["id"] as! Int
        self.productId = dictionary["product_id"] as! Int
        self.imageTypeId = dictionary["image_type_id"] as! Int
        self.image = dictionary["image"] as! String
        self.imageUrl = dictionary["image_url"] as! String
    }
}
