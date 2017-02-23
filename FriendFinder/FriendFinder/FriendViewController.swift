//
//  FriendViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/22/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat"]
    var defaults = UserDefaults.standard
    @IBOutlet var barSearch: UISearchBar!
    @IBOutlet var tableFriend: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = defaults.string(forKey: "user")
        {
            print(name)
            
        }
        self.navigationController?.isNavigationBarHidden = true
        tableFriend.delegate = self
        tableFriend.dataSource = self
        tableFriend.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
//        tableFriend.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = tableFriend.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        
        cell.lblname.text = self.animals[indexPath.row]
        return cell
    }


}
