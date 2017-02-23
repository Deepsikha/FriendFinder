import UIKit
import MapKit

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var imgQRCode: UIImageView!
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var segMenuBar: UISegmentedControl!
    @IBOutlet var tblFriendList: UITableView!
    @IBOutlet var tblUserDetails: UITableView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    
    let defaults = UserDefaults.standard
    var friendlist: [AnyObject]!
    var userdetail: [AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        segMenuBar.selectedSegmentIndex = 0
        switchTable(self)
    }
    @IBAction func switchTable(_ sender: Any) {
        switch (segMenuBar.selectedSegmentIndex) {
        case 0:
                tblUserDetails.isHidden = false
                tblUserDetails.delegate = self
                tblUserDetails.dataSource = self
                tblUserDetails.register(UINib(nibName: "UserDetailCell", bundle: nil), forCellReuseIdentifier: "UserDetailCell")
                tblFriendList.isHidden = true
                imgQRCode.isHidden = true
                tblUserDetails.reloadData()
            break
            
        case 1:
                tblFriendList.isHidden = false
                tblFriendList.delegate = self
                tblFriendList.dataSource = self
                tblFriendList.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
                tblUserDetails.isHidden = true
                imgQRCode.isHidden = true
                tblFriendList.reloadData()
            break

        default:
                imgQRCode.isHidden = false
                tblUserDetails.isHidden = true
                tblFriendList.isHidden = true
            break

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView.tag == 0){
            return userdetail.count
        }else{
            return friendlist.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView.tag == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailCell", for: indexPath) as! UserDetailCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! friendCell
            
            return cell
        }
    }
}
