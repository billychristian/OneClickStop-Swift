//
//  ProductAPIClient.swift
//  OneStopClick
//
//  Created by Billy Christian on 01/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct ProductAPIClient{
    
    static func getProductHomeAPI(completion: @escaping ([Product]?) ->Void){
        let url = "http://172.19.13.156/home/products"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                var products : [Product] = []
                let result = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                
                for item in result{
                    if let productsResult = item["products"] as? [[String:Any]]{
                        for productItem in productsResult{
                            let newProduct = Product(dictionary: productItem)
                            
                            if let productImages = productItem["images"] as? [[String:Any]]{
                                for image in productImages{
                                    let newImage = ProductImage(dictionary:image)
                                    newProduct.productImage?.append(newImage)
                                }
                            }
                            
                            products.append(newProduct)
                        }
                    }
                }
                
                completion(products)
            } catch {
                print("Could not get API data. \(error), \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    static func getProductListFromCategoryId(categoryId : Int, completion: @escaping([Product]?) -> Void){
        let url = "http://172.19.13.156/home/category/\(categoryId)/1"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                var products : [Product] = []
                let result = try JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
                
                for item in result{
                    if let productsResult = item["products"] as? [[String:Any]]{
                        for productItem in productsResult{
                            let newProduct = Product(dictionary: productItem)
                            
                            if let productImages = productItem["images"] as? [[String:Any]]{
                                for image in productImages{
                                    let newImage = ProductImage(dictionary:image)
                                    newProduct.productImage?.append(newImage)
                                }
                            }
                            
                            products.append(newProduct)
                        }
                    }
                }
                
                completion(products)
            } catch {
                print("Could not get API data. \(error), \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
