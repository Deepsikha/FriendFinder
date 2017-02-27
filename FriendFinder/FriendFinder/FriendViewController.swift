import UIKit

class FriendViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    var filteredFriendList: [AnyObject]! = []
    var resultSearchController = UISearchController()
    
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray! = []
    
    var userdetail: NSDictionary!
    
  
    @IBOutlet var tableFriend: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        if let name = defaults.string(forKey: "user")
        {
            print(name)
            
        }

        self.navigationController?.isNavigationBarHidden = true
        self.tableFriend.delegate = self
        self.tableFriend.dataSource = self
        self.tableFriend.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableFriend.tableHeaderView = controller.searchBar
            
            return controller
        })()
        self.tableFriend.reloadData()
        
        
    }

    //MARK: - Fetching Data
    func fetchData(){
        
        let parameters = ["username": defaults.string(forKey: "user")!] as Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "friends", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
            
        }, response_Array: { (resultsArr) in
            DispatchQueue.main.async {
                self.friendlist = resultsArr
                print(self.friendlist)
                self.tableFriend.reloadData()
            }
        }, isTokenEmbeded: false)
        
    }

    //MARK: - Table Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filteredFriendList.count
        } else {
            return friendlist.count
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = friendInfoViewController()
        let cell = tableView.cellForRow(at: indexPath) as! friendCell
        if (self.resultSearchController.isActive) {
            
                vc.relation = cell.status
                vc.username = filteredFriendList[indexPath.row].value(forKey: "username") as? String
                self.navigationController?.pushViewController(vc, animated: true)
        } else {
            vc.relation = cell.status
            vc.username = (friendlist.object(at: indexPath.row) as AnyObject).value(forKey: "username") as? String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = tableFriend.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        if (self.resultSearchController.isActive) {
            cell.lblname?.text = filteredFriendList[indexPath.row].value(forKey: "username") as? String
            
            cell.reloadTable(String(describing: filteredFriendList[indexPath.row].value(forKey: "user_id")!))
            return cell
        }else{
            //cell.backgroundColor = self.colors[indexPath.row]
           cell.lblname.text = (friendlist.object(at: indexPath.row) as AnyObject).value(forKey: "username") as? String
            cell.reloadTable(String(describing: (friendlist.object(at: indexPath.row) as AnyObject).value(forKey: "user_id")!))
            return cell
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        filteredFriendList.removeAll()
        
        let parameters:[String:String] = ["searchTerm":searchController.searchBar.text!,"searchedby":UserDefaults.standard.value(forKey: "user") as! String]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "searchUser", Request_parameter: parameters, Request_parameter_Images: nil, status: { (result) in
            
        }, response_Dictionary: { (json) in
            
        }, response_Array: { (resultarr) in
            DispatchQueue.main.async {
                self.filteredFriendList = resultarr as [AnyObject]
                print(self.filteredFriendList)
                self.tableFriend.reloadData()
            }
        }, isTokenEmbeded: false)
        
    }
    

}
