import UIKit
import MapKit

class HomeViewController: UIViewController {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var barNavigate: UITabBar!
    
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray!
    var userdetail: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.height / 2
//        barNavigate.image?.alignmentRectInsets.bottom
        imgProfile.image = genQRCode()
        fetchData()
        
    }
    
    func fetchData(){
        
        let parameters = ["username": defaults.string(forKey: "user")!] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "user", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
                print(resultsArr)
                self.userdetail = (resultsArr.object(at: 0) as AnyObject) as! NSDictionary
//                self.lblUsername.text = "Username: " + (self.userdetail.value(forKey: "username") as? String)!
                self.lblName.text = (self.userdetail.value(forKey: "name") as? String)!
                self.lblAddress.text = (self.userdetail.value(forKey: "locality") as? String)!
                
            }
        }, isTokenEmbeded: false)
        
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
