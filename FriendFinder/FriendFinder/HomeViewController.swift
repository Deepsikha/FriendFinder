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
    @IBOutlet var imgPropic: UILabel!
    @IBOutlet var btnQrCode: UIButton!
    @IBOutlet var btnlogout: UIButton!
    
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray!
    var userdetail: NSDictionary!
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
        let btnbac = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.done, target: AnyObject.self, action: #selector(btnback))
        self.navigationItem.setLeftBarButtonItems([btnbac], animated: true)
        //(btnbac, animated: true)
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        imgProfile.layer.borderWidth = 2
        
        btnlogout.layer.cornerRadius = 8
        btnQrCode.layer.cornerRadius = 8
        
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.height / 2
//        imgProfile.image = genQRCode()
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
                self.imgPropic.text = (self.userdetail.value(forKey: "name") as? String)!.components(separatedBy: " ").reduce("") { $0.0 + String($0.1.characters.first!)}.uppercased()
                print(self.imgPropic)
                
            }
        }, isTokenEmbeded: false)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "user")
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @IBAction func showQR(_ sender: UIButton) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        let QRView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 135, y: self.view.frame.height / 2 - 151, width: 270, height:270))
        QRView.backgroundColor = UIColor.white
        QRView.alpha = 1.0
        
        let image = UIImageView(image: genQRCode())
        image.alpha = 1
        image.frame = CGRect(x: 35, y: 30, width: 200, height: 200)
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: QRView
            .frame.width, height: 30))
        lbl.textAlignment = .center
        lbl.text = lblUsername.text! + "'s QR Code"
        
        let btn  = UIButton(frame: CGRect(x: QRView.frame.width / 2 - 50, y: 240, width: 100, height: 30))
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.addTarget(self, action: #selector(close), for: .touchDown)
        
        QRView.addSubview(lbl)
        QRView.addSubview(image)
        QRView.addSubview(btn)
        UIView.animate(withDuration: 2) {
        self.view.addSubview(QRView)
        }
        
        
    }
    
    func close(){
        UIView.animate(withDuration: 2) {
            self.view.subviews[self.view.subviews.count - 1 ].alpha = 0
            self.view.subviews[self.view.subviews.count - 2 ].alpha = 0
        }
        (self.view.subviews.last)?.removeFromSuperview()
        (self.view.subviews.last)?.removeFromSuperview()
        
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
