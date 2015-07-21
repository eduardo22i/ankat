//
//  LoginViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/20/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginButton.roundCorners()
        
    }
    
    override func viewDidAppear(animated: Bool) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction (sender : AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["email","public_profile", "user_friends"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                } else {
                    println("User logged in through Facebook!")
                }
                NSNotificationCenter.defaultCenter().postNotificationName("changeToMainScreen", object: nil)
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }

        
    }
}
