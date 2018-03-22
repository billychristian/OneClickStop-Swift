//
//  CategoryCollectionViewCell.swift
//  OneStopClick
//
//  Created by Billy Christian on 27/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet var categoryName: UILabel!
    
    func displayContent(name : String){
        categoryName.text = name
    }
}
