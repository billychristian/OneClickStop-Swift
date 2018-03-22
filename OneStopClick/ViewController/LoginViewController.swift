//
//  LoginViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 26/01/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper
import LocalAuthentication

class LoginViewController: UIViewController, GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    var usernameFromKeychain : String?
    var passwordFromKeychain : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameFromKeychain = KeychainWrapper.standard.string(forKey: "username")
        //print("Username : \(String(describing: usernameFromKeychain))")
        
        self.passwordFromKeychain = KeychainWrapper.standard.string(forKey: "password")
        //print("Password : \(String(describing: passwordFromKeychain))")
        
        if((self.usernameFromKeychain != nil && self.passwordFromKeychain != nil) && UserDefaults.standard.object(forKey: "isLogin") != nil){
            authenticateUser()
        }
        
        googleButton.layer.cornerRadius = 0.5 * googleButton.bounds.size.width
        googleButton.clipsToBounds = true
        googleButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        facebookButton.layer.cornerRadius = 0.5 * facebookButton.bounds.size.width
        facebookButton.clipsToBounds = true
        
        twitterButton.layer.cornerRadius = 0.5 * twitterButton.bounds.size.width
        twitterButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func authenticateUser(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "Login to App",
                                   reply: { (success, error) in
                                    if success {
                                        self.loginThroughAPI(username: self.usernameFromKeychain!, password: self.passwordFromKeychain!)
                                        print("TouchId succeed")
                                    } else {
                                        if let error = error as? NSError {
                                            if error.code != LAError.userCancel.rawValue{
                                                let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                                                self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                                            }
                                        }
                                    }
            })
        }
    }
    
    func errorMessageForLAErrorCode(errorCode: Int) -> String {
        switch errorCode {
        case LAError.appCancel.rawValue:
            return "Authentication was cancelled by application"
        case LAError.authenticationFailed.rawValue:
            return "The user failed to provide valid credentials"
        case LAError.invalidContext.rawValue:
            return "The context is invalid"
        case LAError.passcodeNotSet.rawValue:
            return "Passcode is not set on the device"
        case LAError.systemCancel.rawValue:
            return "Authentication was cancelled by the system"
        case LAError.biometryLockout.rawValue:
            return "Too many failed attempts"
        case LAError.biometryNotAvailable.rawValue:
            return "TouchID is not available on the device"
        case LAError.userCancel.rawValue:
            return "The user did cancel"
        default:
            return "Did not find error code on LAError object"
        }
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showAlertViewAfterEvaluatingPolicyWithMessage(message: String) {
        showAlertWithTitle(title: "Error", message: message)
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailField.text!
        let password = passwordField.text!
        
        if email.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Email is required")
            return
        }
        
        if password.isEmpty{
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: "Password is required")
            return
        }
        
        self.loginThroughAPI(username: email, password: password)
        
    }
    
    func loginThroughAPI(username: String, password: String){
        let params = ["username": username, "password": password] as Dictionary<String, String>
        
        WebService.DoPostCall(operation: WebService.WebServiceOperation.login, params: params) {
            (data, response, error) in
            do {
                let result = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                if result.count > 0 {
                    if let _ = result["error"] {
                        let message = result["message"] as! String
                        PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: message)
                    }
                    else{
                        Credential.sharedInstance.accessToken = result["access_token"] as! String
                        Credential.sharedInstance.isLogin = true
                        Credential.sharedInstance.refreshToken = result["refresh_token"] as! String
                        Credential.sharedInstance.expiresIn = result["expires_in"] as! Int
                        Credential.sharedInstance.tokenType = result["token_type"] as! String
                        Credential.sharedInstance.source = "local"
                        
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        UserDefaults.standard.set("local", forKey: "source")
                        
                        if self.usernameFromKeychain != nil{
                            let _: Bool = KeychainWrapper.standard.removeObject(forKey: "username")
                            print("Username is removed")
                        }
                        
                        let storedUsernameSuccessfully : Bool = KeychainWrapper.standard.set(username, forKey: "username")
                        print("username save was successful: \(storedUsernameSuccessfully)")
                        
                        if self.passwordFromKeychain != nil{
                            let _: Bool = KeychainWrapper.standard.removeObject(forKey: "password")
                            print("Password is removed")
                        }
                        let storedPasswordSuccessfully : Bool = KeychainWrapper.standard.set(password, forKey: "password")
                        print("password save was successful: \(storedPasswordSuccessfully)")
                        
                        Credential.sharedInstance.getUserDetailFromAPI{
                            self.redirectToHomePage()
                        }
                    }
                }
            }
            catch let error {
                let message = "Error occured : \(error)"
                PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: message)
            }
        }
    }
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            Credential.sharedInstance.accessToken = user.authentication.idToken
            Credential.sharedInstance.isLogin = true
            Credential.sharedInstance.source = "google"
            
            Credential.sharedInstance.user = User.init(tokenId: user.authentication.idToken, fullName: user.profile.name, email: user.profile.email, imageUrl: user.profile.imageURL(withDimension: 200))
            
            UserDefaults.standard.set(true, forKey: "isLogin")
            UserDefaults.standard.set("google", forKey: "source")
            
            self.redirectToHomePage()
            // ...
        } else {
            let message = "Error occured : \(error)"
            PopupAlert.ShowOKAlert(view: self, type: PopupAlert.AlertType.error, text: message)
        }
    }
    
    @IBAction func loginFacebookAction(sender: AnyObject) {//action of the custom button in the storyboard
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    UserDefaults.standard.set(true, forKey: "isLogin")
                    UserDefaults.standard.set("fb", forKey: "source")
                    self.redirectToHomePage()
                }
            })
        }
    }
    
    func redirectToHomePage(){
        DispatchQueue.main.async(execute: {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let targetController = storyBoard.instantiateViewController(withIdentifier: "home")
            self.present(targetController, animated: true, completion: nil)
        })
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
