//
//  Product.swift
//  OneStopClick
//
//  Created by Billy Christian on 27/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

class Product: NSObject{
    var id : Int
    var productName : String
    var packageCode : String
    var price : Double
    var productDescription : String
    var compatibility : String
    var urlDownload : String
    var status : String
    var createdDate : Date
    var categoryId : Int
    var subCategoryId : Int
    var productImage : [ProductImage]? = []
    
    init(dictionary: [String: Any]){
        self.id = dictionary["id"] as! Int
        self.productName = dictionary["product_name"] as! String
        self.packageCode = dictionary["package_code"] as! String
        
        if let price = (dictionary["price"] as? NSString)?.doubleValue{
            self.price = price
        }
        else{
            self.price = 0
        }
        self.productDescription = dictionary["description"] as! String
        self.compatibility = dictionary["compatibility"] as! String
        self.urlDownload = dictionary["urldownload"] as! String
        self.status = dictionary["status"] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss"
        self.createdDate = dateFormatter.date(from: dictionary["created"] as! String)!
        
        self.categoryId = dictionary["category_id"] as! Int
        self.subCategoryId = dictionary["sub_category_id"] as! Int
    }
    
}
