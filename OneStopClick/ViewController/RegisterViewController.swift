//
//  RegisterViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 01/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        let confirmPassword = confirmPasswordField.text!
        
        if name.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Name is required")
            return
        }
        
        if email.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Email is required")
            return
        }
        
        if password.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Password is required")
            return
        }
        
        if confirmPassword.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Password Confirmation is required")
            return
        }
        else if(password != confirmPassword){
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Password and Password Confirmation is not matched")
            return
        }
        
        // provide register parameters
        let params = ["name": name, "password": password, "password_confirmation": confirmPassword, "email": email] as Dictionary<String, String>
        
        // call register web service / API
        WebService.DoPostCall(operation: WebService.WebServiceOperation.register, params: params) {
            (data, response, error) in
            do {
                let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                if result.count > 0 {
                    let message = result["message"] as! String
                    let responseCode = result["code"] as! Int?
                    if responseCode == 200 {
                        PopupAlert.ShowOkAlertWithNavigation(view: self, type: PopupAlert.AlertType.success, text: message, target: "login")
                    }
                    else {
                        PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: message)
                    }
                }
            } catch let error {
                let message = "Error occured : \(error)"
                PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: message)
            }
        }
        
        
        //presentViewController(LoginViewController, animated: true, completion: nil)
        
        //PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.success, text: "Your user account has been successfully registered")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
