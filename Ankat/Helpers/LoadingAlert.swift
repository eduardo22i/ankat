//
//  LoadingAlert.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/31/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class LoadingAlert: NSObject {

    var currentViewController : UIViewController!
    var messageAlertView : UIViewController!
    
    func startLoading() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        messageAlertView = storyboard.instantiateViewControllerWithIdentifier("informationMessageViewController") as! InformationMessageViewController
        messageAlertView.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        
        if let currentViewController = currentViewController {
            currentViewController.presentViewController(messageAlertView, animated: false, completion: { () -> Void in
            
            })
        }
    }
    
    func stopLoading () {
        //messageAlertView.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        //})
    }
    
}
