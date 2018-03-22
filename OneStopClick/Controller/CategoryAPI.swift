//
//  CategoryAPI.swift
//  OneStopClick
//
//  Created by Billy Christian on 26/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

struct categoryAPI{
    static func getCategories(completion: @escaping ([String: Any])-> Void){
        //let url = "http://172.19.13.156/api/category"
        let jsonData: [String: Any] = [
                "code": 200,
                "error": false,
                "message": "Data category success loaded",
                "data": [
                    [
                    "id": 3,
                    "text": "Movies"
                    ],
                    [
                    "id": 5,
                    "text": "Books"
                    ],
                    [
                    "id": 4,
                    "text": "Aplications"
                    ],
                    [
                    "id": 6,
                    "text": "Musics"
                    ]
                ]
            ]
        completion(jsonData)
    }
}
