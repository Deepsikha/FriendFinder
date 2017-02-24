//
//  FriendViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/22/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    var friendList = [String]()
    var filteredFriendList = [String]()
    var resultSearchController = UISearchController()
    let defaults = UserDefaults.standard
    var friendlist: NSMutableArray!
    var userdetail: NSDictionary!
    
    @IBOutlet var barSearch: UISearchBar!
    @IBOutlet var tableFriend: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = defaults.string(forKey: "user")
        {
            print(name)
            
        }

        friendList = ["dev_76","dev_30","dev_62"]

        self.navigationController?.isNavigationBarHidden = true
        tableFriend.delegate = self
        tableFriend.dataSource = self
        tableFriend.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
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

    //MARK: - Table Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive) {
            return self.filteredFriendList.count
        } else {
            return self.friendList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = tableFriend.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        if (self.resultSearchController.isActive) {
            cell.lblname?.text = filteredFriendList[indexPath.row]
            cell.btnAdd.setImage(UIImage(named: "addfriend"), for: UIControlState.normal)
            return cell
        }else{
            //cell.backgroundColor = self.colors[indexPath.row]
            cell.lblname.text = self.friendList[indexPath.row]
            
            return cell
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        filteredFriendList.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (friendList as NSArray).filtered(using: searchPredicate)
        filteredFriendList = array as! [String]
        
        self.tableFriend.reloadData()
    }
    

}
