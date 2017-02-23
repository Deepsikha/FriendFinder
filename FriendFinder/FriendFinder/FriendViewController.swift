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

    @IBOutlet var tableFriend: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
