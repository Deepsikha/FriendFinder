import Foundation
import CoreLocation

class Location : NSObject, CLLocationManagerDelegate{
    var locationManager: CLLocationManager = CLLocationManager()
    var defaults = UserDefaults.standard
    
    override init(){
        super.init()
        print("Location")
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 150.0
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // or request always if you need it
        case .restricted, .denied: break
        // tell users that they need to enable access in settings
        default:
            break
        }
        
        
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        print("ABCD")
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
