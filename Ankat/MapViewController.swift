//
//  MapViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
import MapKit

class Artwork: NSObject, MKAnnotation {
    
    var title: String = ""
    var locationName: String = ""
    var discipline: String = ""
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0 , longitude: 0.0)

    
    var recommendation : Offer! {
        didSet {
            if let location = recommendation.location {
                coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
            title = recommendation.name!
        }
    }
    
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(recommendation : Offer) {
        self.recommendation = recommendation
        if let location = recommendation.location {
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
    }
    


    var subtitle: String {
        return recommendation.name ?? ""
    }
    
    
}

class AnnotationView: MKAnnotationView {
    
    
    
    let animationView = UIView(frame: CGRectMake(20, 20, 40, 40))
    var imageView = UIImageView(frame: CGRectMake(20, 20, 40, 40))
    var animator : Animator = Animator()
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        //annotationView.image = UIImage()
        self.frame = CGRectMake(0, 0, 80, 80)
        
        //self.annotation = annotation
        //self.reuseIdentifier = reuseIdentifier
        animationView.backgroundColor = UIColor().appGreenColor()
        animationView.inCircle()
        self.addSubview(animationView)
        animator.loop(animationView)
        
        imageView.image = UIImage(named: "Loading")
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.inCircle()
        imageView.addBorder()
        self.addSubview(imageView)
        
        //self.centerOffset = CGPointMake(40, 40)
        /*
        UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped:)];
        [ann addGestureRecognizer:pinTap];
        */
        
        
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var locationView: UIView!
    @IBOutlet var locationNameLabel: UIView!
    @IBOutlet var locationAddressLabel: UILabel!
    @IBOutlet var localIconImageView: UIImageView!
    
    @IBOutlet var mapView: MKMapView!
    
    var animator2 : Animator? = nil
    
    var mapIsLoading = false
    var didAutoLayout = false
    
    var touchInside = false
    var dragOffset = CGPointMake(0, 0)
    var locationViewPostion = CGPointMake(0, 0)
    
    var locationManager : CLLocationManager = CLLocationManager()
    
    var recommendations : [Offer] = [] {
        didSet {
            //self.tableView.reloadData()
        }
    }
    

    var hasLoadedFirstLocation = false
    let metersMiles = 1609.344
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var mapViewBottomConstraint: NSLayoutConstraint!

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
        /*
        let tapBarGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideShowBarOnTap:"));
        tapBarGestureRecognizer.delegate = self;
        self.mapView.addGestureRecognizer(tapBarGestureRecognizer)
        */
        
        
        
        
        
        
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        
        mapView.showsUserLocation = true
        
        
    }

    override func viewWillAppear(animated: Bool) {
        recommendations = []
        mapViewBottomConstraint.constant = 0


    }
    override func viewDidAppear(animated: Bool) {
        self.locationManager.startUpdatingLocation()
        
        locationView.alpha = 0
       
        
        let location = locationManager.location
        
        if ((location) != nil) {
            let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1 * metersMiles, 1 * metersMiles)
            mapView.setRegion(viewRegion, animated: true)
            
            NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: Selector("waitToShow"), userInfo: nil, repeats: false)
            
        }

        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
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
    
    func loadAnimation2 () {
        if  (locationManager.location == nil) {
            return
        }
        
        if  recommendations.count > 0 {
            
            let recommendation =  recommendations[0]
            
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

   
    
    func hideShowBarOnTap (rec : UITapGestureRecognizer) {
        
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            if self.mapViewBottomConstraint.constant == 0  {
                //self.navigationController?.navigationBar.hidden = false
                self.mapViewBottomConstraint.constant = self.view.frame.height/2 - 30
                //self.tabBarController?.tabBar.hidden = true
                
                self.animator?.fadeDown(self.locationView)
            } else {
                //self.navigationController?.navigationBar.hidden = true
                self.mapViewBottomConstraint.constant = 0
                //self.tabBarController?.tabBar.hidden = false
                self.animator?.fadeIn(self.locationView, direction: AnimationDirection.Top)
            }
            self.view.layoutIfNeeded()
            
        }) { (ended : Bool) -> Void in
            
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
            offerDetailVC.recommendation = recommendations[0]
            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(offerDetailVC, animated: true) { () -> Void in
            }
        }
        
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
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        self.showInformation("Location Unreachable")
    }
    
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
    
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let view =  annotation as? MKUserLocation {
            return nil
        }
        
        let viewId = "MKPinAnnotationView";
        var annotationView =  self.mapView.dequeueReusableAnnotationViewWithIdentifier(viewId)
        if annotationView == nil {
            //annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: viewId)
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: viewId)
        }
        
        if let annotationView = annotationView as? AnnotationView {
            if let annotation = annotation as? Artwork {
                
                
                annotation.recommendation.downloadImageWithBlock({ (data : NSData?, error: NSError?) -> Void in
                    if error == nil {
                        
                        annotationView.clipsToBounds = true
                        annotationView.canShowCallout = false
                        
                        annotationView.imageView.image = UIImage(data: data!)
                        
                        annotationView.layoutIfNeeded()
                        
                    }
                })
                
            }
            
        }
        
        return annotationView
        
    }
    

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        println("Press")
        if let annotaion = view.annotation as? Artwork {
            
            mapView.deselectAnnotation(annotaion, animated: false)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let offerDetailVC = storyboard.instantiateViewControllerWithIdentifier("offerDetailViewController") as! OfferDetailViewController
            offerDetailVC.recommendation = annotaion.recommendation
            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(offerDetailVC, animated: true) { () -> Void in
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
        
    }
    
    func waitToShow () {
        
        self.showInformation("Searching Nearby", icons : [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!])
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            if PFUser.currentUser() == nil {
                self.viewaAllInMap ()
            } else {
                DataManager.getOffers(["status" : 1], user: PFUser.currentUser()!, completionBlock:  { ( objects : [AnyObject]?, error: NSError?) -> Void in
                    
                    for recommendation in objects as! [Offer] {
                        
                        if DataManager.findOfferDatesInDateInThread(recommendation)  > 0 {
                            
                            if let location = recommendation.location {
                                
                                self.recommendations.append(recommendation)
                                
                                let artwork = Artwork(recommendation: recommendation)
                                //artwork.recommendation = recommendation
                                
                                self.mapView.addAnnotation(artwork)
                            }
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.stopLoading()
                                
                                self.tableView.reloadData()
                                
                                
                            })
                        }
                        
                    }
                    
                })
                
            }
        })
        
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        if mapIsLoading {
            if !hasLoadedFirstLocation {
                hasLoadedFirstLocation = true
                //NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("waitToShow"), userInfo: nil, repeats: false)
            //} else{
                
            }
        }
        mapIsLoading = false
        
    }
    
    func viewaAllInMap () {
        DataManager.getOffers(["status" : 1], completionBlock: { (objects : [AnyObject]?, error: NSError?) -> Void in
            
            for recommendation in objects as! [Offer] {
                
                if DataManager.findOfferDatesInDateInThread(recommendation)  > 0 {
                    
                    if let location = recommendation.location {
                        
                        self.recommendations.append(recommendation)
                        
                        let artwork = Artwork(recommendation: recommendation)
                        //artwork.recommendation = recommendation
                        
                        self.mapView.addAnnotation(artwork)
                    }
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.stopLoading()
                        
                        self.tableView.reloadData()
                        
                        
                    })
                }
                
            }
            
        })
    }
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return recommendations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("offerCell", forIndexPath: indexPath) as! OfferTableViewCell
        
        // Configure the cell...
        if (recommendations.count > indexPath.row) {
        
            let offer = recommendations[indexPath.row]
            cell.offerNameLabel.text = offer.name
            cell.offerAddressLabel.text = offer.address
            offer.downloadImage(cell.offerImage)
            cell.offerImage.inCircle()
        
        }
        
        //cell.alpha = 0
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        animator?.bounces(cell, delay : Double(indexPath.row/10))
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //return self.view.frame.width + 10 + 21 + 10 + 21 + 10
        return 80
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       
        let offer = recommendations[indexPath.row]
            let viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: offer.location.latitude, longitude: offer.location.longitude), 0.05 * metersMiles, 0.05 * metersMiles)
            mapView.setRegion(viewRegion, animated: true)
        
    }
    
    //MARK: Actions
    @IBAction func viewAllInMap (sender : AnyObject) {
        self.showInformation("Searching Nearby", icons : [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!])

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.viewaAllInMap ()
        })
        
    }
    
    @IBAction func viewMap (sender : AnyObject) {
        let constant : CGFloat = (self.mapViewBottomConstraint.constant == 190.0) ? 0.0 : 190.0
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mapViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
            
        })
    }

}


