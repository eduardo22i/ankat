//
//  Extensions.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Extensions: NSObject {
   
}

typealias DownloadComplete = (_ data : Data?, _ error : Error?) -> Void


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
    func startLoading(_ message : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageAlertView = storyboard.instantiateViewController(withIdentifier: "informationMessageViewController") as! InformationMessageViewController
        messageAlertView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        messageAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        messageAlertView.message = message
        messageAlertView.icon = [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!]
        self.present(messageAlertView, animated: false, completion: { () -> Void in
                
        
        })
        
    }
    
    func stopLoading () {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StopLoading"), object: nil)
    }
    
    func stopLoading (_ endLoading : @escaping ()  -> Void) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "StopLoading"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: Double(1.0).dispatchTime) { () -> Void in
            endLoading()
        }
        
       
    }
    
    func showInformation(_ message : String) {
        self.showInformation(message, icons: nil)
    }
    
    func showInformation(_ message : String, icons : [UIImage]?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageAlertView = storyboard.instantiateViewController(withIdentifier: "informationMessageViewController") as! InformationMessageViewController
        messageAlertView.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        messageAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        messageAlertView.message = message
        messageAlertView.shouldDismissWithTap = true
        messageAlertView.shouldDismissWithTime = true
        if icons != nil && icons?.count > 0 {
            messageAlertView.icon = icons!
        } else {
            messageAlertView.icon = [UIImage(named: "Monster 5 A")!, UIImage(named: "Monster 5 B")!]
        }
        
        self.present(messageAlertView, animated: false, completion: { () -> Void in
            
            
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
        self.layer.borderColor = UIColor.white.cgColor
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
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        self.leftView = paddingView
        self.leftViewMode = UITextFieldViewMode.always
    }
}

//MARK: Others

extension UIColor {
    func appGreenColor() -> UIColor {
        return UIColor(red: 80.0/255, green: 145.0/255, blue: 121.0/255, alpha: 1.0)
    }
    func appGreenLigthColor() -> UIColor {
        return UIColor(red: 80.0/255, green: 145.0/255, blue: 121.0/255, alpha: 0.6)
    }
}

extension Double {
    var dispatchTime: DispatchTime {
        get {
            return DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        }
    }
}

extension CLLocation {
    func getWrittenLocation () -> String {
        var writtenlocation = ""
        let geo = CLGeocoder ()
        geo.reverseGeocodeLocation(self) { (places: [CLPlacemark]?, error: Error?) in
            if let places = places {
                if let placemark = places.last {
                    writtenlocation = ""
                    if let subThoroughfare = placemark.subThoroughfare {
                        writtenlocation =  "\(subThoroughfare) "
                    }
                    writtenlocation = "\(writtenlocation)\(placemark.thoroughfare)"
                }
            }
        }
        
        return writtenlocation
    }
}

extension String {
    var length: Int { return self.characters.count         }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}


extension CGPoint {
    func isInside (_ point2: UIView) -> Bool {
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

    func downloadUserImage (_ downloadComplete : @escaping DownloadComplete) {
        if let userP = PFUser.current()  {
            let userPicture = userP["image"] as? PFFile
            userPicture?.getDataInBackground(block: { (data : Data?, error : Error?) -> Void in
                downloadComplete(data, error)
            })
        }
        
    }
}
//MARK: Controllers

extension UINavigationBar {
    func transparent () {
        
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.isTranslucent = true
        self.backgroundColor = UIColor.clear
        self.shadowImage = UIImage()
        
    }
}

extension UINavigationController {
    func transparent () {
        
        self.navigationBar.transparent()
        self.view.backgroundColor = UIColor.clear
        
    }
}
