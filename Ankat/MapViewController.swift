//
//  MapViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import MapKit

class Artwork: NSObject, MKAnnotation {
    let title: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String {
        return locationName
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    @IBOutlet var locationView: UIView!
    @IBOutlet var locationNameLabel: UIView!
    @IBOutlet var locationAddressLabel: UILabel!
    @IBOutlet var localIconImageView: UIImageView!
    
    @IBOutlet var mapView: MKMapView!
    
    var dataManager : DataManager? = DataManager()
    var animator2 : Animator? = nil
    
    var mapIsLoading = false
    var didAutoLayout = false
    
    var touchInside = false
    var dragOffset = CGPointMake(0, 0)
    var locationViewPostion = CGPointMake(0, 0)
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    let recommendations = NSMutableArray()
    
    var hasLoadedFirstLocation = false
    let metersMiles = 1609.344
    
    //MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        animator2 = Animator(referenceView: self.view)
        
        //self.navigationController?.transparent()
        
        mapIsLoading = true
        locationView.alpha = 0
        locationViewPostion = CGPointMake(self.view.center.x, locationView.center.y)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("showDetailOffer:"));
        tapGestureRecognizer.delegate = self;
        self.locationView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapBarGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideShowBarOnTap:"));
        tapBarGestureRecognizer.delegate = self;
        self.mapView.addGestureRecognizer(tapBarGestureRecognizer)
        
        
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        
        mapView.showsUserLocation = true
        
        
        
        if let recommendation = dataManager?.getRecommendation(nil)   {
            
            recommendation.location = CLLocationCoordinate2D(latitude: ( 0.009), longitude: ( 0.009 ) )
            
            recommendations.addObject(recommendation)
            
                let artwork = Artwork(title: recommendation.title ,
                    locationName: recommendation.address,
                    discipline: "Sculpture",
                    coordinate: recommendation.location)
                
                mapView.addAnnotation(artwork)
            
        }
        
        
    }

    override func viewDidAppear(animated: Bool) {
        self.locationManager.startUpdatingLocation()
        
        locationView.alpha = 0
        
        if !mapIsLoading {
            //animator2?.snapAnimate(locationView)
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("waitToShow"), userInfo: nil, repeats: false)
        }
        
        
        let location = locationManager.location

        
        if ((location) != nil) {
            let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1 * metersMiles, 1 * metersMiles)
            mapView.setRegion(viewRegion, animated: true)
        }
        
        
    }
    
    func loadAnimation2 () {
        if  (locationManager.location == nil) {
            return
        }
        
        if let recommendation =  recommendations[0] as? Recommendation {
            
            let location = locationManager.location
            
            
            let center = CLLocationCoordinate2D(latitude:  ( (location.coordinate.latitude + recommendation.location.latitude) / 2 ), longitude:  ( (location.coordinate.longitude + recommendation.location.longitude) / 2 ))
            
            
            if ((location) != nil) {
                let viewRegion = MKCoordinateRegionMakeWithDistance(center, 2 * metersMiles, 2 * metersMiles)
                mapView.setRegion(viewRegion, animated: true)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        didAutoLayout = true
        //locationView.center =  CGPointMake(self.view.center.x + locationView.frame.width/2 , locationView.center.y)
    }
    
    override func viewDidLayoutSubviews() {
        if didAutoLayout {
            animator2?.snapAnimate(locationView)
        }
        locationViewPostion = CGPointMake(self.view.center.x, locationView.center.y)
        didAutoLayout = false
    }
    
    func hideShowBarOnTap (rec : UITapGestureRecognizer) {
        if self.navigationController?.navigationBar.hidden == true  {
            self.navigationController?.navigationBar.hidden = false
        } else {
            self.navigationController?.navigationBar.hidden = true
        }
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        animator2?.snapAnimate(locationView)
    }
    
    func showDetailOffer (rec : UITapGestureRecognizer) {
        
        if rec.state == UIGestureRecognizerState.Ended {
            animator2?.snapAnimate(locationView)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let offerDetailVC = storyboard.instantiateViewControllerWithIdentifier("offerDetailViewController") as! OfferDetailViewController
            offerDetailVC.recommendation = recommendations.objectAtIndex(0) as! Recommendation
            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(offerDetailVC, animated: true) { () -> Void in
            }
        }
        
    }
    
    //MARK: Maps
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        /*
        CLLocation *location = locations.lastObject;
        [[self labelLatitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.latitude]];
        [[self labelLongitude] setText:[NSString stringWithFormat:@"%.6f", location.coordinate.longitude]];
        [[self labelAltitude] setText:[NSString stringWithFormat:@"%.2f feet", location.altitude*METERS_FEET]];
        
        // zoom the map into the users current location
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2*METERS_MILE, 2*METERS_MILE);
        [[self mapView] setRegion:viewRegion animated:YES];
        */
        
    }
    //MARK: Touches
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch : AnyObject in touches {
            let location : CGPoint = touch.locationInView(self.view)
            if  location.isInside(locationView) {
                dragOffset = CGPointMake(location.x - locationView.center.x, location.y - locationView.center.y)
                touchInside = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if !touchInside {
            return
        }
        for touch : AnyObject in touches {
            let location : CGPoint = touch.locationInView(self.view)
            locationView.center = CGPointMake(location.x - dragOffset.x, location.y - dragOffset.y)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touchInside {
            animator2?.snapAnimate(locationView, toLocation: locationViewPostion)
        }
        touchInside = false
    }
    
    //MARK: Map Delegate
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        
    }
    
    func waitToShow () {
        
        locationView.alpha = 1
        animator2?.snapAnimate(locationView)
        //loadAnimation2 ()
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        if mapIsLoading {
            if !hasLoadedFirstLocation {
                hasLoadedFirstLocation = true
                NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("waitToShow"), userInfo: nil, repeats: false)
            //} else{
                
            }
        }
        mapIsLoading = false
        
    }
}


