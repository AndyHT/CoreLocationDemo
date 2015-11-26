//
//  ViewController.swift
//  CoreLocationDemo
//
//  Created by Teng on 11/26/15.
//  Copyright © 2015 Teng. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var pointLocation:CLLocation? = nil
    var locationManager:CLLocationManager? = nil
    var geocoder:CLGeocoder? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let location = self.pointLocation {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "Current"
            annotation.subtitle = "You"
            mapView.addAnnotation(annotation)
        }
        
        self.mapView.userTrackingMode = .Follow
        self.mapView.mapType = .Standard
        if (locationManager == nil) {
            locationManager = CLLocationManager()
        }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Restaurants"
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                return
            }
            
            for item in response.mapItems {
                // ...
                print("ITEM:\(item.name)")
            }
        }
        
        geocoder = CLGeocoder()
    }
    
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) -> Void in
            if (placemarks?.count == 0 || error == nil) {
                print("Can't find place")
                return
            }
            
            let pm = placemarks?.first
            
            userLocation.title = pm?.locality
            userLocation.subtitle = pm?.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
