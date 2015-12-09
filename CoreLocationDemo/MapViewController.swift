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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let location = self.pointLocation {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = "CoreLocaiont获得的定位"
            annotation.subtitle = "You"
            mapView.addAnnotation(annotation)
        }
        
        self.mapView.userTrackingMode = .Follow
        self.mapView.mapType = .Standard
        
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = "Restaurants"
//        request.region = mapView.region
//        
//        let search = MKLocalSearch(request: request)
//        search.startWithCompletionHandler { (response, error) in
//            guard let response = response else {
//                print("Search error: \(error)")
//                return
//            }
//            
//            for item in response.mapItems {
//                // ...
//                print("ITEM:\(item.name)")
//            }
//        }
        
    }
    
//    @IBAction func backAction(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    @IBAction func searchPlace(sender: AnyObject) {
        //地图查找，用一个AlertView来获得要查找的信息，然后在tableView中显示查找到的内容，点击cell可以在地图上显示该点（放置一个大头针）
        
    }
    
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) -> Void in
            if (placemarks?.count == 0 || error == nil) {
                print("Can't find place")
                return
            }
            
            let pm = placemarks?.first
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: (pm!.location?.coordinate)!, span: span)
            self.mapView.setRegion(region, animated: true)
            userLocation.title = "MapKit获得的定位"
            userLocation.subtitle = "You"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    //实现路径规划
    
    //图层该怎么弄
}
