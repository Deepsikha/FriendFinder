//
//  mapViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class mapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var mapTable: UITableView!
    @IBOutlet var mapNearfriend: MKMapView!
    @IBOutlet var mapView: UIView!
    var friendlist: NSMutableArray! = []
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        print(locManager.location!)
        
        let app = AppDelegate()
        app.locationManager(locManager, didUpdateLocations: [(locManager.location)!])
        
        mapTable.delegate = self
        self.mapTable.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
        mapTable.tableHeaderView = self.mapView
        
        mapNearfriend.delegate = self
     
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(2, 2)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapNearfriend.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    //MARK: - Table Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func fetchData(){
        
        let parameters = ["username": UserDefaults.standard.string(forKey: "user")!] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "friends", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
              
                for i in resultsArr {
                    
                    if(((i as AnyObject).value(forKey: "location") as! String) != ""){
                        let loc = ((i as AnyObject).value(forKey: "location") as! String).components(separatedBy: ",")
                        let userLoc = CLLocation(latitude: Double(loc[0])!,longitude: Double(loc[1])!)
                        if((self.locManager.location?.distance(from: userLoc))! < CLLocationDistance(10000)){
                            self.friendlist.add(i)
                        }
                    }
                }
                
                self.mapTable.reloadData()
            }
        }, isTokenEmbeded: false)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = mapTable.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        
        cell.btnAdd.isHidden = true
        //cell.lblname =
        return cell
    }
    
    
}
