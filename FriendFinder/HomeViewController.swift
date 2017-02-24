import UIKit
import MapKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgQRCode: UIImageView!
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var segMenuBar: UISegmentedControl!
    @IBOutlet var tblFriendList: UITableView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray!
    var userdetail: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.image = genQRCode()
        fetchData()
        
        segMenuBar.selectedSegmentIndex = 0
    }
    @IBAction func switchTable(_ sender: Any) {
        switch (segMenuBar.selectedSegmentIndex) {
        case 0:
                tblFriendList.isHidden = false
                tblFriendList.delegate = self
                tblFriendList.dataSource = self
                tblFriendList.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
                imgQRCode.isHidden = true
                tblFriendList.reloadData()
            break

        default:
            
                imgQRCode.isHidden = false
                tblFriendList.isHidden = true
            break

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return friendlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
                cell.lblname.text = (friendlist.object(at: indexPath.row) as AnyObject).value(forKey: "username") as? String
            return cell
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
                self.lblName.text = "Name: " + (self.userdetail.value(forKey: "name") as? String)!
                self.lblAddress.text = "Address: " + (self.userdetail.value(forKey: "locality") as? String)!
                
            }
        }, isTokenEmbeded: false)
        
        let parameters1 = ["username": defaults.string(forKey: "user")!] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "friends", Request_parameter: parameters1, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
                print(resultsArr)
                self.friendlist = resultsArr
            }
        }, isTokenEmbeded: false)
//        switchTable(self)
        
        
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
