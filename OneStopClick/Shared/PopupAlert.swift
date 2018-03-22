//
//  PopupAlert.swift
//  OneStopClick
//
//  Created by Billy Christian on 01/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit

struct PopupAlert{
    struct AlertType{
        static let success = "Success"
        static let error = "Error"
    }
    
    static func ShowOKAlert(view: UIViewController, type: String, text: String){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: type, message : text, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            
            alertController.addAction(okAction)
            view.present(alertController, animated: true, completion: nil)
        })
    }
    
    static func ShowOkAlertWithNavigation(view: UIViewController, type: String, text: String, target: String){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: type, message : text, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let targetController = storyBoard.instantiateViewController(withIdentifier: target)
                    view.present(targetController, animated: true, completion: nil)
            })
            
            alertController.addAction(okAction)
            view.present(alertController, animated: true, completion: nil)
        })
    }
}
