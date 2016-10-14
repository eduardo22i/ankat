//
//  OfferDetailViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class OfferDetailViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate {

    var recommendation : Offer!
    
     var imagePickerController: UIImagePickerController?

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var offerNameLabel: UILabel!
    @IBOutlet var offerAddressButton: UIButton!
    @IBOutlet var offerDescriptionView: UITextView!
    @IBOutlet var offerCoverImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var offerPriceLabel: UILabel!
    @IBOutlet var subcategoryIcon: UIImageView!
    @IBOutlet var flagContentButton: UIButton!
    
    @IBOutlet var monsterAnimation: FrameAnimations!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        //animator = Animator(referenceView: self.view)
        alphaAll ()
        
        if let recommendation = recommendation {
            self.title = recommendation.name
        	offerNameLabel.text = recommendation.name
        	offerAddressButton.setTitle(recommendation.address, for: UIControlState())
            offerDescriptionView.text = recommendation.brief
            offerPriceLabel.text = "$ " + recommendation.price.stringValue
            
            recommendation.downloadImage(offerCoverImageView)
            recommendation.subcategory?.fetchIfNeeded()
            recommendation.subcategory?.downloadImage(subcategoryIcon)
            
            recommendation.createdBy?.fetchIfNeeded()
            
            recommendation.downloadUserImage(profileImageView)
            
            if let location = recommendation.location {
            
                let geo = CLGeocoder ()
                geo.reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), completionHandler: { (places :[CLPlacemark]?, error : Error?) in
                
                    if let placemark = places!.last {
                        var locationtitle = ""
                        if let subThoroughfare = placemark.subThoroughfare {
                            locationtitle =  "\(subThoroughfare) "
                        }
                        locationtitle = "\(locationtitle)\(placemark.thoroughfare)"
                        self.offerAddressButton.setTitle(locationtitle, for: UIControlState())
                    }
                })
                
            }
            
        }
        
        
        addStyle ()
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OfferDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        scrollView.delegate = self
        
        monsterAnimation.monsterType = MonsterTypes.monster1
    }
    
    
    func rotated() {
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
            offerCoverImageView.frame.size = CGSize(width: self.view.frame.width, height: 200)
        } else {
            print("Portrait")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.transparent()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animator?.fadeIn(offerNameLabel, direction: AnimationDirection.top)
        animator?.fadeIn(offerAddressButton, delay: 0.1, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        
        animator?.fadeIn(offerPriceLabel, delay: 0.2, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        animator?.fadeIn(subcategoryIcon, delay: 0.2, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        
        
        animator?.fadeIn(offerDescriptionView, delay: 0.3, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        animator?.fadeIn(profileImageView, delay: 0.3, direction: AnimationDirection.top , velocity: AnimationVelocity.fast)

    }

    override func viewWillDisappear(_ animated: Bool) {
        offerNameLabel.alpha = 0
        offerAddressButton.alpha = 0
        profileImageView.alpha = 0
        
        self.tabBarController?.tabBar.isHidden = false
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func alphaAll () {
        offerNameLabel.alpha = 0
        offerAddressButton.alpha = 0
        profileImageView.alpha = 0
        offerDescriptionView.alpha = 0
        offerPriceLabel.alpha = 0
        subcategoryIcon.alpha = 0

    }

    
    func addStyle () {
        profileImageView.inCircle()
        
        offerDescriptionView.font = UIFont(name: "Helvetica", size: 17)
        offerDescriptionView.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
        
        let viewApp: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 60.0))
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = viewApp.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        self.offerCoverImageView.layer.insertSublayer(gradient, at: 0)

    }
    
    // MARK: - Scroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point : CGPoint = targetContentOffset.pointee
        print(point)
        if velocity.y < -0.3 {
            animator?.fadeDown(self.view, delay: 0.0, blockAn: { (ended : Bool, error : NSError?) -> Void in
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //(0.0, -0.575803784422473)
        //(0.0, -3.74141514207355)
        
    }
    // MARK: - Actions
    
    @IBAction func openMaps(_ sender: AnyObject) {
        
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Do you want to open this address in the Mapp App?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Open in Maps", style: .default) { (action) in
            
            if let  addressToLinkTo = "http://maps.apple.com/?q=\(self.offerAddressButton!.titleLabel?.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) {
                
                let url = URL(string: addressToLinkTo)
                UIApplication.shared.openURL(url!)
            }
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "editRecommendation" {
            let vc = segue.destination as? AddOfferInformationViewController
            vc?.recommendation = recommendation
        }
    }
    
    
    // MARK: - Actions
   
    @IBAction func flagContent(_ sender: AnyObject) {
        //self.showInformation("Thanks!")
        
        let alert = UIAlertView(title: "Thanks!", message: "Are you sure to want to flag this content? Your case will go under review", delegate: self, cancelButtonTitle: "Cancel")
        alert.addButton(withTitle: "I'm sure")
        alert.delegate = self
        alert.show()
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            recommendation.status = 2
            recommendation.saveInBackground()
            self.dismissView(self)
        }
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        monsterAnimation.alpha = 0
        
        animator?.fadeDown(offerDescriptionView)
        
        animator?.fadeDown(offerPriceLabel, delay : 0.1)
        animator?.fadeDown(subcategoryIcon, delay : 0.1)
        
        animator?.fadeDown(offerAddressButton, delay : 0.2)
        animator?.fadeDown(offerNameLabel, delay : 0.3)
        
        animator?.fadeDown(profileImageView, delay: 0.4, blockAn: { (ended : Bool, error : NSError?) -> Void in
            self.dismiss(animated: true, completion: { () -> Void in
                
            })
        })
        
    }

}
