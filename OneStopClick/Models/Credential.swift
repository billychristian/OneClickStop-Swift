//
//  Credential.swift
//  OneStopClick
//
//  Created by Billy Christian on 08/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import Foundation

final class Credential {
    static let sharedInstance = Credential()
    private init(){}
    
    var isLogin : Bool = false
    var accessToken : String = ""
    var refreshToken : String = ""
    var tokenType : String = ""
    var expiresIn : Int = 0
    var source : String = ""
    var user : User?

    func getUserDetailFromAPI(completion : @escaping()->Void){
        UserAPIClient.getUserDetail(authorization: self.tokenType + " " + self.accessToken){ (json) in
            let feed = json?["data"] as! [String:Any]
            let userFeed = feed["user"] as! [String:Any]
            self.user = User.init(dictionary: userFeed)
            completion()
        }
    }
    
}
