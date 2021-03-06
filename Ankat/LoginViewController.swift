//
//  LoginViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/20/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
//import ParseFacebookUtilsV4

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loginButton.roundCorners()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        self.showInformation("Please Login", icons: [ UIImage(named: "Monster 5 A")!, UIImage(named: "Monster 5 B")!])
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isOnBoarding")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToNext() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    //MARK: Cancel 
    
    @IBAction func cancelAction (_ sender : AnyObject) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func loginAction (_ sender : AnyObject) {
        
        PFFacebookUtils.logInInBackground(withReadPermissions: ["email","public_profile", "user_friends"]) { (user: PFUser?, error: Error?) in
            
            if let user = user {
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                self.showInformation("Let's get known", icons : [UIImage(named: "Monster 4 A")!, UIImage(named: "Monster 4 B")!])
                
                
                let graphRequest2 : FBSDKGraphRequest = FBSDKGraphRequest (graphPath:  "me", parameters: ["fields":"about,name,email"])
                graphRequest2.start(completionHandler: { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in

                    if let result = result as? NSDictionary {
                        let user = PFUser.current()
                        user!["name"] = result["name"]
                        user!["email"] = result["email"]
                        
                        
                        let fbid : String = (result["id"] ?? "") as! String
                        let url = URL(string: "https://graph.facebook.com/\(fbid)/picture?type=large&return_ssl_resources=1")
                        let data = try? Data(contentsOf: url!)
                        let imageFile:PFFile = PFFile(data: data!)
                        
                        user?.setObject(imageFile, forKey: "image")
                        user?.save()
                        
                        //NSNotificationCenter.defaultCenter().postNotificationName("changeToMainScreen", object: nil)
                        self.moveToNext()
                    }
                })
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
                
                self.showInformation("Facebook Login Error")
                
            }
        }

        
    }
}
