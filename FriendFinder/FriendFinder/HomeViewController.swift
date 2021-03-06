//
//  HomeViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray!
    var userdetail: NSDictionary!
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.height / 2
        imgProfile.image = genQRCode()
        fetchData()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        print(locManager.location!)
        let app = AppDelegate()
        app.locationManager(locManager, didUpdateLocations: [(locManager.location)!])
        mapCurrentLocation.delegate = self
        mapCurrentLocation.isScrollEnabled = false
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapCurrentLocation.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func fetchData(){
        
        let parameters = ["username": defaults.string(forKey: "user")!] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "user", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
                print(resultsArr)
                self.userdetail = (resultsArr.object(at: 0) as AnyObject) as! NSDictionary
                self.lblUsername.text = (self.userdetail.value(forKey: "name") as? String)!
                self.lblAddress.text = (self.userdetail.value(forKey: "locality") as? String)!
                
            }
        }, isTokenEmbeded: false)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    func genQRCode() -> UIImage? {
        let data = (defaults.value(forKey: "user")as! String).data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
