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
        offerAddressButton.setTitle(recommendation.address, for: UIControlState())
        offerDescriptionView.text = recommendation.brief
        offerCoverImageView.image = recommendation.image
        
        addStyle ()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddOfferDetailViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        scrollView.delegate = self
        
        monsterAnimation.monsterType = MonsterTypes.monster1
        
        if let userP = PFUser.current()  {
            userP.downloadUserImage({ (data : Data?, error : Error?) -> Void in
                self.profileImageView.image = UIImage(data: data!)!
            })
        }

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
    }
    
    override func viewDidAppear(_ animated: Bool) {

        monsterAnimation.monsterType = MonsterTypes.monster1

        animator?.fadeIn(offerNameLabel, direction: AnimationDirection.top)
        animator?.fadeIn(offerAddressButton, delay: 0.1, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        animator?.fadeIn(offerDescriptionView, delay: 0.2, direction: AnimationDirection.top, velocity: AnimationVelocity.fast)
        animator?.fadeIn(profileImageView, delay: 0.3, direction: AnimationDirection.top , velocity: AnimationVelocity.fast)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        offerNameLabel.alpha = 0
        offerAddressButton.alpha = 0
        profileImageView.alpha = 0
        
        self.tabBarController?.tabBar.isHidden = false
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        monsterAnimation.scrollViewWillBeginDragging(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(velocity)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    // MARK: - Actions
    
    @IBAction func openMaps(_ sender: AnyObject) {
        
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Do you want to open this address in the Mapp App?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Open in Maps", style: .default) { (action) in
            
            let  addressToLinkTo = "http://maps.apple.com/?q=\(self.offerAddressButton!.titleLabel?.text!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!
            
            let url = URL(string: addressToLinkTo)
            UIApplication.shared.openURL(url!)
            
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func showPhotoSourceSelection() {
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .default) { (action) in
                self.showImagePickerController(.camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .default) { (action) in
            self.showImagePickerController(.photoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        
        self.present(imagePickerController!, animated: true, completion: nil)
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.dismiss(animated: false, completion: nil)
        
        recommendation.image = image
        offerCoverImageView.image = image
        
        cameraButton.alpha = 0.2
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func saveOfferAction(_ sender: AnyObject) {
        let button = sender as! UIBarButtonItem
        startLoading("Saving")
        button.isEnabled = false
        recommendation.uploadPost { (saved: Bool, error: Error?) in
            if (error == nil) {
                self.stopLoading()
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "offerSavedViewController") as! AddOfferSavedViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                button.isEnabled = true
            }
        }
    }
    
    @IBAction func chooseImageAction(_ sender: AnyObject) {
        showPhotoSourceSelection()
    }
    
    @IBAction func dismissView(_ sender: AnyObject) {
        monsterAnimation.alpha = 0
        
        animator?.fadeDown(offerDescriptionView)
        animator?.fadeDown(offerAddressButton, delay : 0.1)
        animator?.fadeDown(offerNameLabel, delay : 0.2)
        animator?.fadeDown(profileImageView, delay: 0.3, blockAn: { (ended : Bool, error : NSError?) -> Void in
            self.dismiss(animated: true, completion: { () -> Void in
                
            })
        })
        
    }

}
