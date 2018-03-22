//
//  ReviewAPIClient.swift
//  OneStopClick
//
//  Created by Billy Christian on 09/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct ReviewAPIClient{
    static func getProductReview(productId : Int, completion: @escaping ([Review]?)-> Void){
        let url = "http://172.19.13.156/api/reviews/\(productId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                var reviews: [Review] = []
                let result = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                
                if let errors = result["error"] as? [String]{
                    for error in errors{
                        print("Error : \(error)")
                    }
                }
                else{
                    if let data = result["data"] as? [[String:Any]]{
                        for item in data{
                            let review = Review(dictionary: item)
                            reviews.append(review)
                        }
                    }
                    completion(reviews)
                }
            } catch {
                print("Could not get API data. \(error), \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
