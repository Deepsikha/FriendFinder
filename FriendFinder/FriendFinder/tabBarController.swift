//
//  tabBarController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class tabBarController: UITabBarController,UITabBarControllerDelegate {

    var tab1: HomeViewController!
    var tab2: FriendViewController!
    var tab3: mapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = delegate
        tabBarController?.tabBar.frame.size.height = 100
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tab1 = HomeViewController()
        tab1.tabBarItem = UITabBarItem(title: "HomeView", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        
        tab2 = FriendViewController()
        tab2.tabBarItem = UITabBarItem(title: "FriendView", image: UIImage(named: "friend"), selectedImage: UIImage(named: "friend"))
        
        tab3 = mapViewController()
        tab3.tabBarItem = UITabBarItem(title: "mapView", image: UIImage(named: "nearby"), selectedImage: UIImage(named: "nearby"))
        
        self.viewControllers = [tab1, tab2, tab3]
        
    }

    

}
