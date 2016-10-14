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
    
    var title: String? = ""
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
    


    var subtitle: String? {
        return recommendation.name ?? ""
    }
    
    
}

class AnnotationView: MKAnnotationView {
    
    
    
    let animationView = UIView(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
    var imageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 40, height: 40))
    var animator : Animator = Animator()
    
    override init(annotation: MKAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        //annotationView.image = UIImage()
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        //self.annotation = annotation
        //self.reuseIdentifier = reuseIdentifier
        animationView.backgroundColor = UIColor().appGreenColor()
        animationView.inCircle()
        self.addSubview(animationView)
        animator.loop(animationView)
        
        imageView.image = UIImage(named: "Loading")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.inCircle()
        imageView.addBorder()
        self.addSubview(imageView)
        
        //self.centerOffset = CGPointMake(40, 40)
        /*
        UITapGestureRecognizer *pinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinTapped:)];
        [ann addGestureRecognizer:pinTap];
        */
        
        
        
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
    var dragOffset = CGPoint(x: 0, y: 0)
    var locationViewPostion = CGPoint(x: 0, y: 0)
    
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
        locationViewPostion = CGPoint(x: self.view.center.x, y: locationView.center.y)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MapViewController.showDetailOffer(_:)));
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

    override func viewWillAppear(_ animated: Bool) {
        recommendations = []
        mapViewBottomConstraint.constant = 0


    }
    override func viewDidAppear(_ animated: Bool) {
        self.locationManager.startUpdatingLocation()
        
        locationView.alpha = 0
       
        
        let location = locationManager.location
        
        if ((location) != nil) {
            let viewRegion = MKCoordinateRegionMakeWithDistance(location!.coordinate, 1 * metersMiles, 1 * metersMiles)
            mapView.setRegion(viewRegion, animated: true)
            
            Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MapViewController.waitToShow), userInfo: nil, repeats: false)
            
        }

        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        didAutoLayout = true
        //locationView.center =  CGPointMake(self.view.center.x + locationView.frame.width/2 , locationView.center.y)
    }
    
    override func viewDidLayoutSubviews() {
        if didAutoLayout {
            animator2?.snapAnimate(locationView)
        }
        locationViewPostion = CGPoint(x: self.view.center.x, y: locationView.center.y)
        didAutoLayout = false
    }
    
    func loadAnimation2 () {
        if  (locationManager.location == nil) {
            return
        }
        
        if  recommendations.count > 0 {
            
            let recommendation =  recommendations[0]
            
            let location = locationManager.location
            
            
            let center = CLLocationCoordinate2D(latitude:  ( (location!.coordinate.latitude + recommendation.location.latitude) / 2 ), longitude:  ( (location!.coordinate.longitude + recommendation.location.longitude) / 2 ))
            
            
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

   
    
    func hideShowBarOnTap (_ rec : UITapGestureRecognizer) {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            
            if self.mapViewBottomConstraint.constant == 0  {
                //self.navigationController?.navigationBar.hidden = false
                self.mapViewBottomConstraint.constant = self.view.frame.height/2 - 30
                //self.tabBarController?.tabBar.hidden = true
                
                self.animator?.fadeDown(self.locationView)
            } else {
                //self.navigationController?.navigationBar.hidden = true
                self.mapViewBottomConstraint.constant = 0
                //self.tabBarController?.tabBar.hidden = false
                self.animator?.fadeIn(self.locationView, direction: AnimationDirection.top)
            }
            self.view.layoutIfNeeded()
            
        }) { (ended : Bool) -> Void in
            
        }
        
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        animator2?.snapAnimate(locationView)
    }
    
    func showDetailOffer (_ rec : UITapGestureRecognizer) {
        
        if rec.state == UIGestureRecognizerState.ended {
            animator2?.snapAnimate(locationView)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let offerDetailVC = storyboard.instantiateViewController(withIdentifier: "offerDetailViewController") as! OfferDetailViewController
            offerDetailVC.recommendation = recommendations[0]
            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(offerDetailVC, animated: true) { () -> Void in
            }
        }
        
    }
    
    
    //MARK: Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            let location : CGPoint = touch.location(in: self.view)
            if  location.isInside(locationView) {
                dragOffset = CGPoint(x: location.x - locationView.center.x, y: location.y - locationView.center.y)
                touchInside = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchInside {
            return
        }
        for touch : AnyObject in touches {
            let location : CGPoint = touch.location(in: self.view)
            locationView.center = CGPoint(x: location.x - dragOffset.x, y: location.y - dragOffset.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchInside {
            animator2?.snapAnimate(locationView, toLocation: locationViewPostion)
        }
        touchInside = false
    }
    
    
     //MARK: Map Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showInformation("Location Unreachable")
    }
    
    // TODO:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
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
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let _ =  annotation as? MKUserLocation {
            return nil
        }
        
        let viewId = "MKPinAnnotationView";
        var annotationView =  self.mapView.dequeueReusableAnnotationView(withIdentifier: viewId)
        if annotationView == nil {
            //annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: viewId)
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: viewId)
        }
        
        if let annotationView = annotationView as? AnnotationView {
            if let annotation = annotation as? Artwork {
                
                annotation.recommendation.downloadImageWithBlock({ (data : Data?, error: Error?) in
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
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotaion = view.annotation as? Artwork {
            
            mapView.deselectAnnotation(annotaion, animated: false)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let offerDetailVC = storyboard.instantiateViewController(withIdentifier: "offerDetailViewController") as! OfferDetailViewController
            offerDetailVC.recommendation = annotaion.recommendation
            offerDetailVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            offerDetailVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(offerDetailVC, animated: true) { () -> Void in
            }
        }
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    func waitToShow () {
        
        self.showInformation("Searching Nearby", icons : [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!])
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            
            if PFUser.current() == nil {
                self.viewaAllInMap ()
            } else {
                DataManager.getOffers(["status" : 1], user: PFUser.current()!, completionBlock:  { ( objects : [Any]?, error: Error?) -> Void in
                    
                    for recommendation in objects as! [Offer] {
                        
                        if DataManager.findOfferDatesInDateInThread(recommendation)  > 0 {
                            
                            if recommendation.location != nil {
                                
                                self.recommendations.append(recommendation)
                                
                                let artwork = Artwork(recommendation: recommendation)
                                //artwork.recommendation = recommendation
                                
                                self.mapView.addAnnotation(artwork)
                            }
                            
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.stopLoading()
                                
                                self.tableView.reloadData()
                                
                                
                            })
                        }
                        
                    }
                    
                })
                
            }
        })
        
    }
    
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
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
        DataManager.getOffers(["status" : 1], completionBlock: { (objects : [Any]?, error: Error?) -> Void in
            
            for recommendation in objects as! [Offer] {
                
                if DataManager.findOfferDatesInDateInThread(recommendation)  > 0 {
                    
                    if recommendation.location != nil {
                        
                        self.recommendations.append(recommendation)
                        
                        let artwork = Artwork(recommendation: recommendation)
                        //artwork.recommendation = recommendation
                        
                        self.mapView.addAnnotation(artwork)
                    }
                    
                    
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.stopLoading()
                        
                        self.tableView.reloadData()
                        
                        
                    })
                }
                
            }
            
        })
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return recommendations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerCell", for: indexPath) as! OfferTableViewCell
        
        // Configure the cell...
        if (recommendations.count > (indexPath as NSIndexPath).row) {
        
            let offer = recommendations[(indexPath as NSIndexPath).row]
            cell.offerNameLabel.text = offer.name
            cell.offerAddressLabel.text = offer.address
            offer.downloadImage(cell.offerImage)
            cell.offerImage.inCircle()
        
        }
        
        //cell.alpha = 0
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        animator?.bounces(cell, delay : Double((indexPath as NSIndexPath).row/10))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return self.view.frame.width + 10 + 21 + 10 + 21 + 10
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
       
        let offer = recommendations[(indexPath as NSIndexPath).row]
            let viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: offer.location.latitude, longitude: offer.location.longitude), 0.05 * metersMiles, 0.05 * metersMiles)
            mapView.setRegion(viewRegion, animated: true)
        
    }
    
    //MARK: Actions
    @IBAction func viewAllInMap (_ sender : AnyObject) {
        self.showInformation("Searching Nearby", icons : [UIImage(named: "Monster 2 A")!, UIImage(named: "Monster 2 B")!])

        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: { () -> Void in
            self.viewaAllInMap ()
        })
        
    }
    
    @IBAction func viewMap (_ sender : AnyObject) {
        let constant : CGFloat = (self.mapViewBottomConstraint.constant == 190.0) ? 0.0 : 190.0
        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.mapViewBottomConstraint.constant = constant
            self.view.layoutIfNeeded()
            
        })
    }

}


