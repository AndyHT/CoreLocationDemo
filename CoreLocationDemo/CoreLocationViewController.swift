//
//  CoreLocationViewController.swift
//  CoreLocationDemo
//
//  Created by Teng on 11/26/15.
//  Copyright © 2015 Teng. All rights reserved.
//

import UIKit
import CoreLocation

class CoreLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager? = nil
    
    var pointLocation:CLLocation? = nil
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationAuthority()
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
    
    func startStandardUpdates() {
        if (locationManager == nil) {
            locationManager = CLLocationManager()
        }
        
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        locationManager!.distanceFilter = 500   //500米
        
        locationManager!.startUpdatingLocation()
    }
    
    
    func checkLocationAuthority() {
        
        let locationAuthorization = CLLocationManager.authorizationStatus()
        
        switch locationAuthorization {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            print("permission")
            //允许使用定位
            
            startStandardUpdates()
            
        case .Denied, .Restricted:
            print("restricted")
            //没有获得授权，不允许使用定位
            //给用户提示，请求获得授权
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        case .NotDetermined:
            print("notDetermined")
            //向用户申请授权
            locationManager = CLLocationManager()
            self.locationManager!.requestWhenInUseAuthorization()
            
            startStandardUpdates()
        }
        
    }
    
    //locationManager定位失败时delegate会调用该函数通知App
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if let locationError = CLError(rawValue: error.code) {
            // ...
            switch locationError {
            case .LocationUnknown:
                print("无法获得当前定位")
            case .Network:
                print("网络异常，无法获得当前定位")
            case .Denied:
                print("用户拒绝App使用定位服务")
            default:
                print("其他原因导致无法使用定位服务")
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        //修改distanceFilter和定位精度以降低能耗
        
    }


    
    /*
    *
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            self.pointLocation = currentLocation
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapView" {
            let nextController = segue.destinationViewController as! MapViewController
            nextController.pointLocation = self.pointLocation
            print("latitude:\(self.pointLocation!.coordinate.latitude)")
            print("longitude:\(self.pointLocation!.coordinate.longitude)")
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //当用户修改定位权限时给用户提示申请定位权限
    }
}
