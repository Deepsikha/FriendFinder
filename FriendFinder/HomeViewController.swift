import UIKit
import MapKit

class HomeViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet var lblName: UILabel!
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
        Location()
        self.navigationController?.isNavigationBarHidden = true
        
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.height / 2
        imgProfile.image = genQRCode()
        fetchData()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        print(locManager.location!)
        let a = locManager.location!.coordinate.latitude
        let b = locManager.location!.coordinate.longitude
        
        let location = CLLocationCoordinate2DMake(a,b)
        let annotation = MKPointAnnotation()
        mapCurrentLocation.delegate = self
        mapCurrentLocation.removeAnnotation(annotation as MKAnnotation)
        annotation.coordinate = location
        annotation.title = "Current Location"
        mapCurrentLocation.addAnnotation(annotation)
        
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
                self.lblUsername.text = "Username: " + (self.userdetail.value(forKey: "username") as? String)!
                self.lblName.text = (self.userdetail.value(forKey: "name") as? String)!
                self.lblAddress.text = (self.userdetail.value(forKey: "locality") as? String)!
                
            }
        }, isTokenEmbeded: false)
        
    }
    @IBAction func Friends(_ sender: Any) {
        self.navigationController?.pushViewController(FriendViewController(), animated: true)
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

/*SELECT x.username,y.status FROM (
SELECT users.username,users.user_id from users WHERE users.user_id IN (
SELECT if(relationship.user_one_id != 10,
relationship.user_one_id,
if(relationship.user_two_id != 10,
relationship.user_two_id,false)
) from relationship where
relationship.user_one_id = 10 OR relationship.user_two_id = 10
)
) as x
INNER JOIN
(
SELECT if(relationship.user_one_id != 10,
relationship.user_one_id,
if(relationship.user_two_id != 10,
relationship.user_two_id,false)
) as id,relationship.status from relationship where
relationship.user_one_id = 10 OR relationship.user_two_id = 10
) as y
ON x.user_id = y.id*/
