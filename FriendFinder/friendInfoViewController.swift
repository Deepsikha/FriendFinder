import UIKit
import MapKit

class friendInfoViewController: UIViewController,MKMapViewDelegate {

  
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgPro: UIImageView!
    @IBOutlet var lblCaption: UILabel!
    var latlng: [String]!
    var username: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        mapView.delegate = self
        
        mapView.layer.cornerRadius = mapView.frame.height / 2
        
        fetchData()
        
        lblCaption.text = username! + "'s Recent Location"
    }
    
    func fetchData(){
        
        let parameters: [String:String] = ["username" : username!]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "user", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in

        }, response_Array: { (arr) in
            let user = (arr.object(at: 0) as AnyObject) as! NSDictionary
            
            self.lblUsername.text = (user.value(forKey: "username") as? String)!
            self.lblName.text = (user.value(forKey: "name") as? String)!
            let location = (user.value(forKey: "location") as? String)!
            
            self.latlng = location.components(separatedBy: ",")
            
            let mapAnnotation = MKPointAnnotation()
            mapAnnotation.coordinate = CLLocationCoordinate2DMake(Double(self.latlng[0])!,Double(self.latlng[1])!)
            mapAnnotation.title = self.username! + "'s recent location"
            self.mapView.removeAnnotation(mapAnnotation as MKAnnotation)
            self.mapView.addAnnotation(mapAnnotation as MKAnnotation)
            
            let span = MKCoordinateSpanMake(0.05,0.05)
            let region = MKCoordinateRegionMake(mapAnnotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
            
        }, isTokenEmbeded: false)
    }
    @IBAction func showQR(_ sender: Any) {
        
        let QRView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 100, width: 200, height:270))
        QRView.backgroundColor = UIColor.white
        QRView.alpha = 0.7
        let image = UIImageView(image: QRCode(username!))
        image.alpha = 1
        image.frame = CGRect(x: 0, y: 40, width: 200, height: 200)
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: QRView
            .frame.width, height: 40))
        lbl.textAlignment = .center
        
        lbl.text = username! + "'s QRCode"
        
        let btn  = UIButton(frame: CGRect(x: QRView.frame.width / 2 - 50, y: 240, width: 100, height: 30))
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        
        btn.addTarget(self, action: #selector(close), for: .touchDown)
        QRView.addSubview(lbl)
        QRView.addSubview(image)
        QRView.addSubview(btn)
        UIView.animate(withDuration: 2) { 
        self.view.addSubview(QRView)
        }
        
    }
    func close(){
        (self.view.subviews.last)?.removeFromSuperview()
    }
    func QRCode(_ str: String) -> UIImage?{
        let data = (str.data(using: String.Encoding.ascii))
        
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
