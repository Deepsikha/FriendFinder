//
//  friendInfoViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import MapKit

class friendInfoViewController: UIViewController {
    
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblLocate: UILabel!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.size.height/2
        
        
        lblLocate.text = "\(lblUsername)'s recent Location"
        
    }
    
    func fetchData(){
        
        let parameters = ["username": username] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "user", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
                print(resultsArr)
                let userdetail = (resultsArr.object(at: 0) as AnyObject) as! NSDictionary
                self.lblUsername.text = (userdetail.value(forKey: "name") as? String)!
                self.lblAddress.text = (userdetail.value(forKey: "locality") as? String)!
                let location = (userdetail.value(forKey: "location") as? String)!
                
                let latlng = location.components(separatedBy: ",")
                
                let anno = MKPointAnnotation()
                anno.coordinate = CLLocationCoordinate2DMake(Double(latlng[0])! ,Double(latlng[1])!)
                self.mapCurrentLocation.removeAnnotation(anno as MKAnnotation)
                anno.title = "Current Location"
                self.mapCurrentLocation.addAnnotation(anno)
                
            }
        }, isTokenEmbeded: false)
        
    }


}
