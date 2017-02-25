//
//  mapViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import MapKit

class mapViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mapTable: UITableView!
    @IBOutlet var mapNearfriend: MKMapView!
    @IBOutlet var mapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        mapTable.delegate = self
        self.mapTable.register(UINib(nibName: "friendCell", bundle: nil), forCellReuseIdentifier: "friendCell")
        
        mapTable.tableHeaderView = self.mapView
     
    }
    
    //MARK: - Table Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:friendCell = mapTable.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! friendCell
        
        cell.btnAdd.isHidden = true
        //cell.lblname =
        return cell
    }
    
    
}
