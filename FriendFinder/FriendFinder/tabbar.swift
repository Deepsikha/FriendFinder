//
//  tabBarController.swift
//  FriendFinder
//
//  Created by devloper65 on 2/24/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class tabbar: UITabBarController,UITabBarControllerDelegate {

    var tab1: HomeViewController!
    var tab2: FriendViewController!
    var tab3: mapViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Logout"
        self.delegate = delegate
        tabBarController?.tabBar.frame.size.height = 100
        
    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        
        tabFrame.size.height = 49
        tabFrame.origin.y = self.view.frame.size.height - 49
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tab1 = HomeViewController()
        tab1.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
        tab1.tabBarItem.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0)

        tab2 = FriendViewController()
        tab2.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "friend"), selectedImage: UIImage(named: "friend"))
        tab2.tabBarItem.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0)
        
        tab3 = mapViewController()
        tab3.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "nearby"), selectedImage: UIImage(named: "nearby"))
        tab3.tabBarItem.imageInsets  = UIEdgeInsetsMake(6, 0, -6, 0)

        
        self.viewControllers = [tab1, tab2, tab3]
        
    }

    

}
