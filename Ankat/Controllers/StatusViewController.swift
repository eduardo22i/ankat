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
    var hourDateFormatter = HourDateFormatter()
    var userPreferences : [Preference] = []
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var message1Label: UILabel!
    @IBOutlet var message2Label: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    
    //MARK: View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.delegate = self
        //locationManager.
        hourDateFormatter.setTargetsLabel(timeLabel, dateTargetLabel: dateLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.transparent()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        locationManager.startUpdatingLocation()
        
        message1Label.alpha = 0
        message2Label.alpha = 0
        addressLabel.alpha = 0
        timeLabel.alpha = 0
        dateLabel.alpha = 0
        searchButton.alpha = 0
        
        hourDateFormatter.start()
        
        //searchButton.addRoundBorder()
        searchButton.roundCorners()
        
        if PFUser.current() != nil {
            searchMyPreferences()
        }
        
        let defaults = UserDefaults.standard
        if (self.locationManager.location == nil) {
            defaults.set(false, forKey: "userLocation")
        } else {
            defaults.set(true, forKey: "userLocation")
        }
        defaults.synchronize()
    }

    override func viewDidAppear(_ animated: Bool) {
        animator?.fadeIn(message1Label, delay: 0.0, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
        animator?.fadeIn(addressLabel, delay: 0.1, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
        animator?.fadeIn(message2Label, delay: 0.2, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
        animator?.fadeIn(timeLabel, delay: 0.3, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
        animator?.fadeIn(dateLabel, delay: 0.4, direction: AnimationDirection.top, velocity: AnimationVelocity.medium)
        
        animator?.bounces(searchButton)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        hourDateFormatter.stop()
        locationManager.stopUpdatingLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: Preps
    
    func resetSearchButton () {
        self.searchButton.setTitle("Search for Best Option", for: UIControlState())
        self.searchButton.isEnabled = true
    }
    
    func searchMyPreferences () {
        searchButton.isEnabled = false
        DataManager.findUserPreferences(PFUser.current()!) { (userPreferences : [Any]?, error : Error?) in
            if let userPreferences = userPreferences as? [PFObject] {
                let preferences = userPreferences.map {
                    $0.object(forKey: "preference") as! Preference
                }
                
                self.userPreferences = preferences
                
                self.searchButton.isEnabled = true
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            //self.addressLabel.text = location.getWrittenLocation()
            
            let geo = CLGeocoder ()
            geo.reverseGeocodeLocation(location, completionHandler: { (places : [CLPlacemark]?, error : Error?) in
                if (error != nil) {
                    return
                }
                if let places = places {
                    if let placemark = places.last {
                        self.addressLabel.text = ""
                        
                        if let subThoroughfare = placemark.subThoroughfare {
                            self.addressLabel.text =  "\(subThoroughfare)\n"
                        }
                        if let thoroughfare = placemark.thoroughfare {
                            self.addressLabel.text = "\(self.addressLabel.text!)\(thoroughfare)"
                        }
                        
                        if self.addressLabel.text == "" {
                            if let name = placemark.name {
                                self.addressLabel.text =  "\(name)"
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    
    // MARK: Actions
    
    @IBAction func search(_ sender : AnyObject) {
        let user = PFUser.current()
        
        searchButton.setTitle("Searching ;)", for: UIControlState())
        searchButton.isEnabled = false
        
        
        if (self.locationManager.location == nil) {
            
            self.showInformation("Location Error")
            
            self.resetSearchButton()
            
            return
        }
        
        self.startLoading("Searching")
        
        if PFUser.current() == nil {
            
            let query = PFQuery(className: DataManager.OfferClass)
            query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude), withinKilometers: 1.0)
            query.order(byAscending: "location")
            
            query.findObjectsInBackground(block: { (offers : [Any]?, error : Error?) -> Void in
                if (error != nil) || (offers?.count == 0)  {
                    
                    self.stopLoading()
                    self.showInformation("Offer Not Found")
                    self.resetSearchButton()
                    
                    return
                }
                
                if let offers = offers as? [Offer] {
                    
                    var offerFound = false
                    
                    var index = 0
                    
                    while !offerFound && offers.count > (index ) {
                        
                        let offer = offers[index]
                        
                        var matchsCount = 0
                        
                        let offerPreferences = DataManager.findOfferPreferencesInThread(offer)
                        
                        let preferences = offerPreferences.map{
                            $0.object(forKey: "preference") as! Preference
                        }
                        
                        for preference in preferences {
                            
                            for selectPreference in self.userPreferences {
                                if selectPreference.objectId! == preference.objectId! {
                                    print("its a match :)")
                                    matchsCount += 1
                                } else {
                                    print("its not a match :(")
                                    
                                }
                            }
                            
                        }
                        
                        if matchsCount == preferences.count &&  DataManager.findOfferDatesInDateInThread(offer)  > 0 {
                            print("Good!")
                            offerFound = true
                            
                            self.stopLoading()
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let offerDetailVC = storyboard.instantiateViewController(withIdentifier: "offerDetailViewController") as! OfferDetailViewController
                            offerDetailVC.recommendation = offer
                            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                            self.present(offerDetailVC, animated: true) { () -> Void in
                                self.searchButton.titleLabel?.text = "Search for Best Option"
                                self.searchButton.isEnabled = true
                            }
                            
                        } else {
                            
                            offerFound = false
                        }
                        
                        index += 1
                        
                    }
                    
                    self.stopLoading()
                    
                    if !offerFound {
                        self.showInformation("Offer Not Found")
                    }
                    
                    self.resetSearchButton()
                    
                }
            })
            

            return
        }
        
        DataManager.findUserSubcategoriesLikes(["user":user!]) { (subcategories : [Any]?, error : Error?) -> Void in
            if let subcategories = subcategories as? [PFObject] {
                let selectedSubcategory = subcategories.map{
                    $0.object(forKey: "subcategory") as! Subcategory
                }
                
                
                
                let query = PFQuery(className: DataManager.OfferClass)
                query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: self.locationManager.location!.coordinate.latitude, longitude: self.locationManager.location!.coordinate.longitude), withinKilometers: 1.0)
                query.whereKey("subcategory", containedIn: selectedSubcategory)
                query.order(byAscending: "location")
                
                query.findObjectsInBackground(block: { (offers : [Any]?, error : Error?) -> Void in
                    if (error != nil) || (offers?.count == 0)  {
                        
                        self.stopLoading()
                        self.showInformation("Offer Not Found")
                        self.resetSearchButton()
                        
                        return
                    }
                    
                    if let offers = offers as? [Offer] {
                        
                        var offerFound = false
                        
                        var index = 0
                        
                        while !offerFound && offers.count > (index ) {
                            
                            let offer = offers[index]
                            
                            if offer.status == 1 {
                                
                                var matchsCount = 0
                                
                                let offerPreferences = DataManager.findOfferPreferencesInThread(offer)
                                
                                let preferences = offerPreferences.map{
                                    $0.object(forKey: "preference") as! Preference
                                }
                                
                                for preference in preferences {
                                    
                                    for selectPreference in self.userPreferences {
                                        if selectPreference.objectId! == preference.objectId! {
                                            print("its a match :)")
                                            matchsCount += 1
                                        } else {
                                            print("its not a match :(")
                                            
                                        }
                                    }
                                    
                                }
                                
                                if matchsCount == preferences.count &&  DataManager.findOfferDatesInDateInThread(offer)  > 0 {
                                    print("Good!")
                                    offerFound = true
                                    
                                    self.stopLoading()
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let offerDetailVC = storyboard.instantiateViewController(withIdentifier: "offerDetailViewController") as! OfferDetailViewController
                                    offerDetailVC.recommendation = offer
                                    offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
                                    offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                                    self.present(offerDetailVC, animated: true) { () -> Void in
                                        self.searchButton.titleLabel?.text = "Search for Best Option"
                                        self.searchButton.isEnabled = true
                                    }
                                    
                                } else {
                                    
                                    offerFound = false
                                }
                                
                                
                            }
                            
                            index += 1
                            
                        }
                        
                        self.stopLoading()
                        
                        if !offerFound {
                            self.showInformation("Offer Not Found")
                        }
                        
                        self.resetSearchButton()
                        
                    }
                })
                
                
            }
        }
        
        
    }

}
