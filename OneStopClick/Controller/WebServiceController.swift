//
//  WebServiceController.swift
//  OneStopClick
//
//  Created by Billy Christian on 01/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct WebService{
    static let webServiceUrl = "http://172.19.13.156/api/"
    
    struct WebServiceOperation{
        static let register = "auth/register"
        static let login = "auth/token"
    }
    
    static func DoPostCall(operation: String, params: Dictionary<String, String>, handler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let url = webServiceUrl + operation
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: handler)
        
        task.resume()
    }
}
