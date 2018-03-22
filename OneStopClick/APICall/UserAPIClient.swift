//
//  UserAPIClient.swift
//  OneStopClick
//
//  Created by Billy Christian on 13/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct UserAPIClient{

    static func getUserDetail(authorization: String, completion: @escaping([String:Any]?)->Void){
        let url = "http://172.19.13.156/api/getuserdetails"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let unwrappedData = data
                else {
                    print("Error unwrapping data")
                    return;
            }
            
            do{
                let responseJson  = try JSONSerialization.jsonObject(with: unwrappedData, options: []) as? [String:Any]
                completion(responseJson)
            }
            catch{
                print("Could not get API data. \(error), \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
