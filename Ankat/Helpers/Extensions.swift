//
//  Extensions.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/10/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

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

}

extension UIImageView {
    func inCircle () {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 50
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

extension String {
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

//MARK: Controllers


extension UINavigationController {
    func transparent () {
        
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.translucent = true
        self.view.backgroundColor = UIColor.clearColor()
        self.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationBar.shadowImage = UIImage()
        
    }
}