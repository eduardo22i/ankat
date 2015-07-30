//
//  AddOfferDetailViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/15/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class AddOfferDetailViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var recommendation : Offer!
    
    var imagePickerController: UIImagePickerController?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var offerNameLabel: UILabel!
    @IBOutlet var offerAddressButton: UIButton!
    @IBOutlet var offerDescriptionView: UITextView!
    @IBOutlet var offerCoverImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var monsterAnimation: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //animator = Animator(referenceView: self.view)
        alphaAll ()
        
        offerNameLabel.text = recommendation.name
        offerAddressButton.setTitle(recommendation.address, forState: UIControlState.Normal)
        offerDescriptionView.text = recommendation.brief
        offerCoverImageView.image = recommendation.image
        
        addStyle ()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        scrollView.delegate = self
        
        monsterAnimation.monsterType = MonsterTypes.Monster1
        
        if let userP = PFUser.currentUser()  {
            userP.downloadUserImage({ (data : NSData?, error :NSError?) -> Void in
                self.profileImageView.image = UIImage(data: data!)!
            })
        }

    }
    
    
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)) {
            offerCoverImageView.frame.size = CGSizeMake(self.view.frame.width, 200)
        } else {
            println("Portrait")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {

        monsterAnimation.monsterType = MonsterTypes.Monster1

        animator?.fadeIn(offerNameLabel, direction: AnimationDirection.Top)
        animator?.fadeIn(offerAddressButton, delay: 0.1, direction: AnimationDirection.Top, velocity: AnimationVelocity.Fast)
        animator?.fadeIn(offerDescriptionView, delay: 0.2, direction: AnimationDirection.Top, velocity: AnimationVelocity.Fast)
        animator?.fadeIn(profileImageView, delay: 0.3, direction: AnimationDirection.Top , velocity: AnimationVelocity.Fast)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        offerNameLabel.alpha = 0
        offerAddressButton.alpha = 0
        profileImageView.alpha = 0
        
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alphaAll () {
        offerNameLabel.alpha = 0
        offerAddressButton.alpha = 0
        profileImageView.alpha = 0
        offerDescriptionView.alpha = 0
        
    }
    
    
    func addStyle () {
        profileImageView.inCircle()
        
        offerDescriptionView.font = UIFont(name: "Helvetica", size: 17)
        offerDescriptionView.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        
    }
    
    // MARK: - Scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        monsterAnimation.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        monsterAnimation.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        println(velocity)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    // MARK: - Actions
    
    @IBAction func openMaps(sender: AnyObject) {
        
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Do you want to open this address in the Mapp App?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Open in Maps", style: .Default) { (action) in
            
            let  addressToLinkTo = "http://maps.apple.com/?q=\(self.offerAddressButton!.titleLabel?.text!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            
            let url = NSURL(string: addressToLinkTo)
            UIApplication.sharedApplication().openURL(url!)
            
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func showPhotoSourceSelection() {
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(false, completion: nil)
        
        recommendation.image = image
        offerCoverImageView.image = image
        
        cameraButton.alpha = 0.2
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func saveOfferAction(sender: AnyObject) {
        let button = sender as! UIBarButtonItem
        button.enabled = false
        recommendation.uploadPost { (saved : Bool, error : NSError?) -> Void in
            if (error == nil) {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("offerSavedViewController") as! AddOfferSavedViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                button.enabled = true
            }
        }
        
    }
    
    @IBAction func chooseImageAction(sender: AnyObject) {
        showPhotoSourceSelection()
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        monsterAnimation.alpha = 0
        
        animator?.fadeDown(offerDescriptionView)
        animator?.fadeDown(offerAddressButton, delay : 0.1)
        animator?.fadeDown(offerNameLabel, delay : 0.2)
        animator?.fadeDown(profileImageView, delay: 0.3, blockAn: { (ended : Bool, error : NSError?) -> Void in
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        })
        
    }

}
