//
//  Extensions.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class Extensions: NSObject {
   
}


//MARK: UIViews

extension UIViewController {
    var hasBounced : Bool? {
        get {
            return self.hasBounced
        }
        
        set  {
            // What do you want to do here?
        }
    }
    
    var animator : Animator? {
        return Animator()
    }

   
    func startLoading() {
        startLoading("Loading")
    }
    func startLoading(message : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageAlertView = storyboard.instantiateViewControllerWithIdentifier("informationMessageViewController") as! InformationMessageViewController
        messageAlertView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        messageAlertView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        messageAlertView.message = message
        messageAlertView.icon = [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!]
        self.presentViewController(messageAlertView, animated: false, completion: { () -> Void in
                
        
        })
        
    }
    
    func stopLoading () {
        NSNotificationCenter.defaultCenter().postNotificationName("StopLoading", object: nil)
    }
    
    func showInformation(message : String) {
        self.showInformation(message, icon: nil)
    }
    
    func showInformation(message : String, icon : UIImage?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageAlertView = storyboard.instantiateViewControllerWithIdentifier("informationMessageViewController") as! InformationMessageViewController
        messageAlertView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        messageAlertView.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        messageAlertView.message = message
        messageAlertView.shouldDismissWithTap = true
        messageAlertView.shouldDismissWithTime = true
        messageAlertView.icon = [UIImage(named: "Monster 5 A")!, UIImage(named: "Monster 5 B")!]
        
        self.presentViewController(messageAlertView, animated: false, completion: { () -> Void in
            
            
        })
    }
    
}

extension UIView {
    func inCircle () {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.width/2
    }
    
    func addRoundBorder () {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    func addBorder () {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
    }
}

extension UIButton {
    func roundCorners () {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
}

extension UITextField {
    func addPadding () {
        let paddingView = UIView(frame: CGRectMake(0, 0, 5, 20))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.Always
    }
}

//MARK: Others

extension UIColor {
    func appGreenColor() -> UIColor {
        return UIColor(red: 80.0/255, green: 145.0/255, blue: 121.0/255, alpha: 1.0)
    }
}

extension CLLocation {
    func getWrittenLocation () -> String {
        var writtenlocation = ""
        let geo = CLGeocoder ()
        geo.reverseGeocodeLocation(self) { (places : [AnyObject]!, error : NSError!) -> Void in
            if let placemark = places.last as? CLPlacemark {
                writtenlocation = ""
                if let subThoroughfare = placemark.subThoroughfare {
                    writtenlocation =  "\(placemark.subThoroughfare) "
                }
                writtenlocation = "\(writtenlocation)\(placemark.thoroughfare)"
            }
        }
        return writtenlocation
    }
}

extension String {
    var length: Int { return count(self)         }
    
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}


extension CGPoint {
    func isInside (point2: UIView) -> Bool {
        if self.x > point2.center.x - point2.frame.width/2 &&
            self.x < point2.center.x + point2.frame.width/2 &&
            self.y > point2.center.y - point2.frame.height/2 &&
            self.y < point2.center.y + point2.frame.height/2 {
                return true
        }
        return false
    }
}

extension PFUser {
    typealias DownloadComplete = (data : NSData?, NSError?) -> Void

    func downloadUserImage (downloadComplete : DownloadComplete) {
        if let userP = PFUser.currentUser()  {
            let userPicture = userP["image"] as? PFFile
            userPicture?.getDataInBackgroundWithBlock({ (data : NSData?, error :NSError?) -> Void in
                downloadComplete(data: data, error)
            })
        }
        
    }
}
//MARK: Controllers

extension UINavigationBar {
    func transparent () {
        
        self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.translucent = true
        self.backgroundColor = UIColor.clearColor()
        self.shadowImage = UIImage()
        
    }
}

extension UINavigationController {
    func transparent () {
        
        self.navigationBar.transparent()
        self.view.backgroundColor = UIColor.clearColor()
        
    }
}