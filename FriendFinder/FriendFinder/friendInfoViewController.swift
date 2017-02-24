//
//  friendInfoViewController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import MapKit

class friendInfoViewController: UIViewController {
    
    @IBOutlet var mapCurrentLocation: MKMapView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblLocate: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        mapCurrentLocation.layer.cornerRadius = mapCurrentLocation.frame.size.height/2
        
        lblLocate.text = "\(lblUsername)'s recent Location"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
