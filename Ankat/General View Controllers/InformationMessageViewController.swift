//
//  InformationMessageViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/31/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

class InformationMessageViewController: UIViewController, UIGestureRecognizerDelegate {
   
    var message = ""
    var shouldDismissWithTap = false
    var shouldDismissWithTime = false
    
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var decorationFrame: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        decorationFrame.monsterType = MonsterTypes.Monster2
        
        messageView.addRoundBorder()
    }
    override func viewWillAppear(animated: Bool) {
        messageLabel.text = message
        if shouldDismissWithTap {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissWithTap:"));
            tapGestureRecognizer.delegate = self;
            self.view.addGestureRecognizer(tapGestureRecognizer)
        }
        if shouldDismissWithTime {
            NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: Selector("dismissWithTime"), userInfo: nil, repeats: false)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("stopThisLoading"), name: "StopLoading", object: nil)
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopThisLoading() {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
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
            
        })
    }
}
