//
//  MapEditFromCellViewController.swift
//  Ankat
//
//  Created by Eduardo Irías on 8/1/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

protocol MapFromCellDelegate {
    func didEndSelectingLocation(location : CLLocation, value : String, indexPath : NSIndexPath)
}

class MapEditFromCellViewController: UIViewController , UINavigationBarDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var delegate : MapFromCellDelegate!
    
    var hasBeganEditing = false
    var annotation : MapPin!
    var key = "Location Search"
    var keyboardType = UIKeyboardType.Default
    
    var locationManager : CLLocationManager = CLLocationManager()
    var currentLocation : CLLocation!
    
    var indexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    let metersMiles = 1609.344

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = key
        
        hasBeganEditing = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        searchBar.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    override func viewDidAppear(animated: Bool) {
        //valueTextField.becomeFirstResponder()
        
        if let location = currentLocation {
            
            self.zoomToLocation(location)
            self.geoDecodeLocation(location)
        } else if  let location = locationManager.location  {
            
            self.zoomToLocation(location)
            self.geoDecodeLocation(location)
            
        }
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UISearchBarDelegate
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let geo = CLGeocoder ()
        geo.geocodeAddressString(searchBar.text, completionHandler: { (places : [AnyObject]!, error : NSError!) -> Void in
            if places == nil || places.count == 0 {
                self.showInformation("Location Not Found")
                return
            }
            if let placemark = places.last as? CLPlacemark {
                self.getLocation(placemark)
                self.zoomToLocation(placemark.location)
                self.currentLocation = placemark.location
            }
            
            
        })
        
        searchBar.resignFirstResponder()
        
    }
    
    
    //MARK: Map Delegate
    
    func getLocation (placemark : CLPlacemark) {
        self.searchBar.text = ""
        var locationStr = ""
        

        if let subThoroughfare = placemark.subThoroughfare {
            locationStr =  "\(placemark.subThoroughfare) "
        }
        if let thoroughfare = placemark.thoroughfare {
            locationStr = "\(locationStr)\(thoroughfare)"
        }
        if locationStr == "" {
            if let subLocality = placemark.subLocality {
                locationStr =  "\(placemark.subLocality)"
            }
        }
        if let locality = placemark.locality {
            locationStr = "\(locationStr), \(locality)"
        }
        
        self.searchBar.text = locationStr
    }
    
    func geoDecodeLocation (location : CLLocation) {
        let geo = CLGeocoder ()
        geo.reverseGeocodeLocation(location) { (places : [AnyObject]!, error : NSError!) -> Void in
            if let placemark = places.last as? CLPlacemark {
                self.getLocation(placemark)
            }
        }
    }
    
    func zoomToLocation(location : CLLocation) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1 * metersMiles, 1 * metersMiles)
        mapView.setRegion(viewRegion, animated: true)
        
        mapView.removeAnnotation(annotation)

        annotation = MapPin(coordinate: location.coordinate, title: "", subtitle: "")
        mapView.addAnnotation(annotation)
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
    
    //MARK: Actions
    
    @IBAction func saveData (sender : AnyObject) {
        if let delegate = delegate {
            
            self.delegate.didEndSelectingLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), value : self.searchBar.text, indexPath: self.indexPath)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
