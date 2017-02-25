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
    var lat : String!
    var long : String!
    var location : String!
    var user : String!
    var parameters : [String:String]!
    
    override init(){
    super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        locationManager.startUpdatingLocation()
        lat = String(describing: (locationManager.location?.coordinate.latitude)!)
        long = String(describing: (locationManager.location?.coordinate.longitude)!)
        location = lat.appending(",").appending(long)
        print(location)
        user = defaults.string(forKey: "user")
        parameters = ["username" : user!,"location" : location]
    server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "loc", Request_parameter: parameters, Request_parameter_Images: nil, status: { (request) in
            
        }, response_Dictionary: { (request) in
            
        }, response_Array: { (request) in
            
        }, isTokenEmbeded: false)

    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        print("12345678")
        user = defaults.string(forKey: "user")
        parameters = ["username" : user!,"location" : location]
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
