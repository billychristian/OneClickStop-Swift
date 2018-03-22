//
//  AccountViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 20/02/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FlagKit
import CoreLocation

class AccountViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Credential.sharedInstance.user
        
        nameLabel.text = user?.name
        emailLabel.text = user?.email
        
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(_ sender: Any) {
        if(UserDefaults.standard.object(forKey: "source") as! String == "google"){
            GIDSignIn.sharedInstance().signOut()
        }
        else if(UserDefaults.standard.object(forKey: "source") as! String == "fb"){
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        else if(UserDefaults.standard.object(forKey: "source") as! String == "local"){
            UserDefaults.standard.removeObject(forKey: "refreshToken")
            UserDefaults.standard.removeObject(forKey: "expiresIn")
        }
        
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "source")
        UserDefaults.standard.removeObject(forKey: "isLogin")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetController = storyBoard.instantiateViewController(withIdentifier: "login")
        self.present(targetController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        //locationLabel.text = userLocation.
        
        let countryCode = Locale.current.regionCode!
        let flag = Flag(countryCode: countryCode)!
        let styledImage = flag.image(style: .circle)
        
        locationImg.image = styledImage
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
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
