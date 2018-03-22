//
//  ProductHomeCollectionViewCell.swift
//  OneStopClick
//
//  Created by Billy Christian on 02/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit

class ProductHomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    func displayContent(title : String, price:Double , imageUrlString : String?){
        self.productTitle.text = title
        if price != 0{
            let priceValue = String(format: "%.2f", price)
            self.productPrice.text = "Rp. \(priceValue)"
            self.productPrice.textColor = UIColor.orange
        }
        
        if let imageUrl = URL(string: imageUrlString!){
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: imageUrl) { (data, response, error) in
                if let e = error {
                    print("Error downloading product picture: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded product picture with response code \(res.statusCode)")
                        if let imageData = data {
                            DispatchQueue.main.async(execute: {
                                let image = UIImage(data: imageData)
                                self.productImage.image = image
                            })
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
                
            downloadPicTask.resume()
            
        }
    }
}
