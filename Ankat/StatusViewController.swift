//
//  StatusViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/22/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse

class StatusViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager = CLLocationManager()
    var userPreferences : [Preference] = []
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var message1Label: UILabel!
    @IBOutlet var message2Label: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController?.transparent()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        locationManager.startUpdatingLocation()
        
        message1Label.alpha = 0
        message2Label.alpha = 0
        addressLabel.alpha = 0
        timeLabel.alpha = 0
        searchButton.alpha = 0
        
        HourDateFormatter().setTargetsLabel(timeLabel, dateTargetLabel: dateLabel)
        
        //searchButton.addRoundBorder()
        searchButton.roundCorners()
        
        searchMyPreferences()
        
    }

    override func viewDidAppear(animated: Bool) {
        animator?.fadeIn(message1Label, delay: 0.0, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium)
        animator?.fadeIn(addressLabel, delay: 0.1, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium)
        animator?.fadeIn(message2Label, delay: 0.2, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium)
        animator?.fadeIn(timeLabel, delay: 0.3, direction: AnimationDirection.Top, velocity: AnimationVelocity.Medium)
        
        animator?.bounces(searchButton)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchMyPreferences () {
        searchButton.enabled = false
        DataManager.findUserPreferences(PFUser.currentUser()!, completionBlock: { (userPreferences : [AnyObject]?, error : NSError?) -> Void in
            
            
            let preferences = userPreferences?.map{
                $0.objectForKey("preference") as! Preference
            }
            
            
            if let preferences = preferences {
                self.userPreferences = preferences
            }
            
            self.searchButton.enabled = true
            
        })
    }
    
    @IBAction func search(sender : AnyObject) {
        let user = PFUser.currentUser()
        
        searchButton.setTitle("Searching ;)", forState: UIControlState.Normal)
        searchButton.enabled = false
        
        DataManager.findUserSubcategoriesLikes(["user":user!]) { (subcategories : [AnyObject]?, error : NSError?) -> Void in
            
            let selectedSubcategory = subcategories?.map{
                $0.objectForKey("subcategory") as! Subcategory
            }
            
            
            
            let query = PFQuery(className: DataManager.OfferClass)
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: self.locationManager.location.coordinate.latitude, longitude: self.locationManager.location.coordinate.longitude), withinKilometers: 1.0)
            query.whereKey("subcategory", containedIn: selectedSubcategory!)
            query.orderByAscending("location")
            
            query.findObjectsInBackgroundWithBlock({ (offers : [AnyObject]?, error : NSError?) -> Void in
                if (error != nil) {
                    return
                }

                if let offers = offers as? [Offer] {
                    
                    var offerFound = false
                    
                    var index = 0
                    while !offerFound || offers.count > index {
                        
                        let offer = offers[index]
                        
                        var matchsCount = 0
                        
                        let offerPreferences = DataManager.findOfferPreferencesInThread(offer)
                        
                        let preferences = offerPreferences.map{
                            $0.objectForKey("preference") as! Preference
                        }
                        
                        for preference in preferences {
                            
                            for selectPreference in self.userPreferences {
                                if selectPreference.objectId! == preference.objectId! {
                                    println("its a match :)")
                                    matchsCount++
                                } else {
                                    println("its not a match :(")
                                    
                                }
                            }
                            
                        }
                        
                        if matchsCount == preferences.count {
                            println("Good!")
                            offerFound = true
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let offerDetailVC = storyboard.instantiateViewControllerWithIdentifier("offerDetailViewController") as! OfferDetailViewController
                            offerDetailVC.recommendation = offer
                            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
                            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                            self.presentViewController(offerDetailVC, animated: true) { () -> Void in
                            self.searchButton.titleLabel?.text = "Search for Best Option"
                            self.searchButton.enabled = true
                            }
                            
                        } else {
                            offerFound = false
                        }
                        
                        index++
                        
                        
                        
                        self.searchButton.setTitle("Search for Best Option", forState: UIControlState.Normal)
                        self.searchButton.enabled = true

                    }
                    
                    
                }
            })
            
            
            
        }
        
        
    }

}