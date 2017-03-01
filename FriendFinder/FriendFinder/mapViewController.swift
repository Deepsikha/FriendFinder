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
    var friendlist: [String]! = []
    var friendloc: [CLLocation]! = []
    var allfriends: [MKAnnotation]! = []
    var locManager = CLLocationManager()
    var routesarr: [MKOverlay] = [MKOverlay]()
    var disch = CLLocationDistance(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 50
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
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    //MARK: - LocationManager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpanMake(2, 2)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapNearfriend.setRegion(region, animated: true)
        }
        mapNearfriend.removeOverlays(routesarr)
//        friendlist.removeAll()
        routesarr.removeAll()
        mapNearfriend.removeAnnotations(allfriends)
        allfriends.removeAll()
        mapTable.reloadData()
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 4.0
            
            return renderer

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
        return friendlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = mapTable.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        
//        cell.lblname = (friendlis.value(forKey: "username") as? String
        let i = indexPath.section
        print(i)
        cell.lblname.text = friendlist[indexPath.row]
        let anno = MKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2DMake(friendloc[indexPath.row].coordinate.latitude, friendloc[indexPath.row].coordinate.longitude)
        anno.title = friendlist[indexPath.row] + "'s recent location"
        self.mapNearfriend.removeAnnotation(anno as MKAnnotation)
        self.mapNearfriend.addAnnotation(anno as MKAnnotation)
        self.createRoutes(location1: (self.locManager.location?.coordinate)!, location2: anno)
        allfriends.append(anno)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    //MARK: - FetchData from server
    
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
                        if((self.locManager.location?.distance(from: userLoc))! <= CLLocationDistance(10000)){
                            self.friendlist.append((i as AnyObject).value(forKey: "username") as! String)
                            self.friendloc.append(userLoc)
                           
                        }else{
                            let anno = MKPointAnnotation()
                            anno.coordinate = CLLocationCoordinate2DMake(userLoc.coordinate.latitude, userLoc.coordinate.longitude)
                            anno.title = (i as AnyObject).value(forKey: "username") as! String + "'s recent location"
                            self.mapNearfriend.removeAnnotation(anno as MKAnnotation)
                            self.mapNearfriend.addAnnotation(anno as MKAnnotation)
//                            self.allfriends.app
                        }
                    }
                }
                print(self.friendlist)
                self.mapTable.reloadData()
            }
        }, isTokenEmbeded: false)
        
    }
    
    
    //MARK: - Routes creation of map
    func createRoutes(location1: CLLocationCoordinate2D,location2: MKPointAnnotation){
        let sourcePlace = MKPlacemark(coordinate: location1, addressDictionary: nil)
        let destinationPlace = MKPlacemark(coordinate: location2.coordinate, addressDictionary: nil)
        
        //        let distance = MKDis
        
        let sourceMapItem = MKMapItem(placemark: sourcePlace)
        let destinationMapItem = MKMapItem(placemark: destinationPlace)
        
        let directionReq = MKDirectionsRequest()
        directionReq.source = sourceMapItem
        directionReq.destination = destinationMapItem
        directionReq.transportType = .automobile
        
        let directions = MKDirections(request: directionReq)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("error in direction generation: \(error)")
                }
                return
            }
            
            
            let route = response.routes[0]
            let distance = route.distance
            print(distance)
            self.routesarr.append(route.polyline)
            self.mapNearfriend.add(route.polyline,level: MKOverlayLevel.aboveRoads)
            location2.subtitle = "\nDistance:"+String(describing: distance)+"meters\nExpectedTime:"+String(describing: route.expectedTravelTime)
            
//            if self.disch < distance {
//                self.disch = distance
//                let rect = route.polyline.boundingMapRect
//            self.mapNearfriend.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//            }
        }
    }
}
