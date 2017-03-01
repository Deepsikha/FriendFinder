import UIKit
import MapKit

class friendInfoViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet var btnRelation: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgPro: UIImageView!
    @IBOutlet var lblCaption: UILabel!
    @IBOutlet var lblProImg: UILabel!
    @IBOutlet var btnQR: UIButton!
    
    var relation: Int!
    var latlng: [String]!
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        mapView.delegate = self
        
        mapView.layer.cornerRadius = mapView.frame.height / 2
        imgPro.layer.borderWidth = 2
        imgPro.layer.cornerRadius = imgPro.frame.size.width / 2
        btnRelation.layer.cornerRadius = 8
        btnQR.layer.cornerRadius = 8
        btnRelation.layer.borderWidth = 1
        lblCaption.text = username! + "'s Recent Location"
        
        changeBtn()
        fetchData()
        
    }
    
    func changeBtn() {
        let color = btnQR.backgroundColor?.cgColor
        if(relation == 1) {
            btnRelation.setTitle("Unfriend", for: .normal)
            btnRelation.setTitleColor(UIColor.white, for: .normal)
            btnRelation.backgroundColor = UIColor.init(cgColor: color!)
            
        } else {
            btnRelation.setTitle("AddFriend", for: .normal)
            btnRelation.setTitleColor(UIColor.black, for: .normal)
            btnRelation.backgroundColor = UIColor.clear
            
        }

    }
    
    func fetchData() {
        
        let parameters: [String:String] = ["username" : username!]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "user", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in

        }, response_Array: { (arr) in
            let user = (arr.object(at: 0) as AnyObject) as! NSDictionary
            
            self.lblUsername.text = (user.value(forKey: "name") as? String)!
            self.lblAddress.text = (user.value(forKey: "locality") as? String)!
            self.lblProImg.text = (user.value(forKey: "name") as? String)!.components(separatedBy: " ").reduce("") { $0.0 + String($0.1.characters.first!)}.uppercased()
            print(self.lblProImg)
            
            let location = (user.value(forKey: "location") as? String)!
            if (location != ""){
                self.latlng = location.components(separatedBy: ",")
                
                let mapAnnotation = MKPointAnnotation()
                mapAnnotation.coordinate = CLLocationCoordinate2DMake(Double(self.latlng[0])!,Double(self.latlng[1])!)
                mapAnnotation.title = self.username! + "'s recent location"
                self.mapView.removeAnnotation(mapAnnotation as MKAnnotation)
                self.mapView.addAnnotation(mapAnnotation as MKAnnotation)
                
                let span = MKCoordinateSpanMake(0.05,0.05)
                let region = MKCoordinateRegionMake(mapAnnotation.coordinate, span)
                self.mapView.setRegion(region, animated: true)
            } else {
                let alert = UIAlertController(title: "No Location", message: "user's location is not updated!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert,animated: true,completion: nil)
            }
            
        }, isTokenEmbeded: false)
    }
    
    @IBAction func showQR(_ sender: Any) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        let QRView = UIView(frame: CGRect(x: self.view.frame.width / 2 - 135, y: self.view.frame.height / 2 - 151, width: 270, height:270))
        QRView.backgroundColor = UIColor.white
        QRView.alpha = 1.0
        
        let image = UIImageView(image: QRCode(username!))
        image.alpha = 1
        image.frame = CGRect(x: 35, y: 30, width: 200, height: 200)
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: QRView
            .frame.width, height: 30))
        lbl.textAlignment = .center
        lbl.text = username! + "'s QR Code"
        
        let btn  = UIButton(frame: CGRect(x: QRView.frame.width / 2 - 50, y: 240, width: 100, height: 30))
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.addTarget(self, action: #selector(close), for: .touchDown)
        btn.backgroundColor = UIColor.lightGray
        
        QRView.addSubview(lbl)
        QRView.addSubview(image)
        QRView.addSubview(btn)
        UIView.animate(withDuration: 2) { 
        self.view.addSubview(QRView)
        }
        
    }
    
    func close(){
        UIView.animate(withDuration: 2.0) {
            self.view.subviews[self.view.subviews.count - 1 ].alpha = 0
            self.view.subviews[self.view.subviews.count - 2 ].alpha = 0
        }
        (self.view.subviews.last)?.removeFromSuperview()
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
    
    @IBAction func changeRelation(_ sender: Any) {
    
    
        var parameter:[String:String] = [:]
        if(relation == 1){
            let alert = UIAlertController(title: "Unfriend", message: "Are You Sure to unfriend the " + username! + "?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Confirm", style: .destructive, handler: { (alertAction) in
                parameter = ["user1":UserDefaults.standard.value(forKey: "user") as! String,"user2":self.username!,"signal":"2"]
                server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "changeRelation", Request_parameter: parameter, Request_parameter_Images: nil, status: { (result) in
            
                }, response_Dictionary: { (json) in
                    DispatchQueue.main.async {
                        if json.value(forKey: "resp") as! String == "changed" {
                            if self.relation == 1{
                                self.relation = 0
                            }else{
                                self.relation = 1
                            }
                            self.changeBtn()
                        }else{
                            let alert = UIAlertController(title: "Error", message: "something went wrong try again later!", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }, response_Array: { (arr) in
                    
                }, isTokenEmbeded: false)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            parameter = ["user1":UserDefaults.standard.value(forKey: "user") as! String,"user2":self.username!,"signal":"1"]
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "changeRelation", Request_parameter: parameter, Request_parameter_Images: nil, status: { (result) in
                
            }, response_Dictionary: { (json) in
                DispatchQueue.main.async {
                    if json.value(forKey: "resp") as! String == "changed" {
                        if self.relation == 1{
                            self.relation = 0
                        }else{
                            self.relation = 1
                        }
                        self.changeBtn()
                    }else{
                        let alert = UIAlertController(title: "Error", message: "something went wrong try again later!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }, response_Array: { (arr) in
                
            }, isTokenEmbeded: false)
        }
        
    }
    
}
