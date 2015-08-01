//
//  LongTextEditFromCellViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 8/1/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit

protocol LongTextEditDelegate {
    func didEndEditingLongText(value : String, indexPath : NSIndexPath)
}

class LongTextEditFromCellViewController: UIViewController , UINavigationBarDelegate {
    
    var delegate : LongTextEditDelegate!
    
    var hasBeganEditing = false
    var key = ""
    var value = ""
    var indexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var keyboardType = UIKeyboardType.Default
    
    @IBOutlet var valueTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //animator = Animator(referenceView: self.view)
        
        self.title = key
        
        valueTextField.alpha = 0
        
        //valueTextField.placeholder = key
        valueTextField.text = value
        
        valueTextField.keyboardType = keyboardType
        
        hasBeganEditing = true
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        valueTextField.frame.inset(dx: 10, dy: 0)
        valueTextField.becomeFirstResponder()
        animator?.fadeIn(valueTextField, delay: 0.1, direction: AnimationDirection.Top, velocity: AnimationVelocity.Fast)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        animator?.fadeDown(valueTextField)
        
    }
    
    func navigationBar(navigationBar: UINavigationBar, didPushItem item: UINavigationItem) {
        if hasBeganEditing {
            let alert = UIAlertView(title: "What?", message: "really?", delegate: self, cancelButtonTitle: "Cancel")
            alert.show()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData (sender : AnyObject) {
        if let delegate = delegate {
            self.delegate.didEndEditingLongText(self.valueTextField.text, indexPath: self.indexPath)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
