//
//  CategoryHelper.swift
//  OneStopClick
//
//  Created by Billy Christian on 27/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct CategoryHelper{
    static let categories : [Int: String] = [3:"Movies", 4:"Applications", 5:"Books", 6:"Music"]
    
    static func getCategoryName(categoryId : Int) -> String{
        return categories[categoryId]!
    }
}
