//
//  OfferDetailViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class OfferDetailViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {

    var recommendation : Offer!
    
     var imagePickerController: UIImagePickerController?

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var offerNameLabel: UILabel!
    @IBOutlet var offerAddressButton: UIButton!
    @IBOutlet var offerDescriptionView: UITextView!
    @IBOutlet var offerCoverImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var monsterAnimation: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //animator = Animator(referenceView: self.view)
        alphaAll ()
        
        if let recommendation = recommendation {
            self.title = recommendation.name
        	offerNameLabel.text = recommendation.name
        	offerAddressButton.setTitle(recommendation.address, forState: UIControlState.Normal)
            offerDescriptionView.text = recommendation.brief
            //offerCoverImageView.image = recommendation.image
            recommendation.downloadImage(offerCoverImageView)
            
            recommendation.createdBy?.fetchIfNeeded()
            println(recommendation.createdBy?.username)
            
            recommendation.downloadUserImage(profileImageView)
            
            if let location = recommendation.location {
            
                let geo = CLGeocoder ()
                
                geo.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude)) { (places : [AnyObject]!, error : NSError!) -> Void in
                    if let placemark = places.last as? CLPlacemark {
                        var locationtitle =  "\(placemark.subThoroughfare) " ?? ""
                        locationtitle = "\(locationtitle)\(placemark.thoroughfare)"
                        self.offerAddressButton.setTitle(locationtitle, forState: UIControlState.Normal)
                    }
                }
                
            }
            
        }
        addStyle ()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)

        scrollView.delegate = self
        
        monsterAnimation.monsterType = MonsterTypes.Monster1
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
        let point : CGPoint = targetContentOffset.memory
        println(point)
        if velocity.y < -0.3 {
            animator?.fadeDown(self.view, delay: 0.0, blockAn: { (ended : Bool, error : NSError?) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //(0.0, -0.575803784422473)
        //(0.0, -3.74141514207355)
        
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editRecommendation" {
            let vc = segue.destinationViewController as? AddOfferInformationViewController
            vc?.recommendation = recommendation
        }
    }
    
    
    // MARK: - Actions
    
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
