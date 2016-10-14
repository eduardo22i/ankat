//
//  InformationMessageViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/31/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class InformationMessageViewController: UIViewController, UIGestureRecognizerDelegate {
   
    typealias completion = () -> Void
    
    var message = ""
    var shouldDismissWithTap = false
    var shouldDismissWithTime = false
    var icon : [UIImage] = []
    
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var decorationFrame: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        decorationFrame.animationImages = icon
        decorationFrame.animationDuration = 0.5
        
        
        messageView.addRoundBorder()
    }
    override func viewWillAppear(animated: Bool) {
        messageLabel.text = message
        if shouldDismissWithTap {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationMessageViewController.dismissWithTap(_:)));
            tapGestureRecognizer.delegate = self;
            self.view.addGestureRecognizer(tapGestureRecognizer)
        }
        if shouldDismissWithTime {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(InformationMessageViewController.dismissWithTime), userInfo: nil, repeats: false)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InformationMessageViewController.stopThisLoading), name: "StopLoading", object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        decorationFrame.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopThisLoading() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "StopLoading", object: nil)

        })
    }
    
    func dismissWithTime () {
        dismissView()
    }
    
    func dismissWithTap(sender : UIGestureRecognizer) {
        dismissView ()
    }
    
    func dismissView () {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            NSNotificationCenter.defaultCenter().removeObserver(self, name: "StopLoading", object: nil)
        })
    }
}
