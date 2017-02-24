//
//  Location.swift
//  FriendFinder
//
//  Created by Developer88 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import Foundation
import CoreLocation

class Location : NSObject, CLLocationManagerDelegate{
    var locationManager: CLLocationManager = CLLocationManager()
    var defaults = UserDefaults.standard

    override init(){
    super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 150
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        let lat = String(describing: locationManager.location?.coordinate.latitude)
        let long = String(describing: locationManager.location?.coordinate.longitude)
        let location = lat.appending(",").appending(long)
        let user = defaults.string(forKey: "user")
        let parameters = ["username" : user!,"location" : location]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "loc", Request_parameter: parameters, Request_parameter_Images: nil, status: { (request) in
            
        }, response_Dictionary: { (request) in
            
        }, response_Array: { (request) in
            
        }, isTokenEmbeded: false)
        
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        
    }
}
