//
//  MainTabBarViewController.swift
//  ScoutMaster
//
//  Created by Sam Roman on 1/27/20.
//  Copyright © 2020 Sam Roman. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    lazy var discoverVC = UINavigationController(rootViewController: DashboardVC())
    lazy var journeyVC = UINavigationController(rootViewController: MapVC())
    lazy var userVC = UINavigationController(rootViewController: ProfileVC())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverVC.isNavigationBarHidden = true
        journeyVC.isNavigationBarHidden = true
        userVC.isNavigationBarHidden = true
        
        discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "search"), tag: 0)
        journeyVC.tabBarItem = UITabBarItem(title: "Journey", image: UIImage(named: "map"), tag: 1)
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), tag: 2)
        
        self.viewControllers = [discoverVC, journeyVC, userVC]
        self.viewControllers?.forEach({$0.tabBarController?.tabBar.barStyle = .default})
        

        // Do any additional setup after loading the view.
    }
    

   

}
/*
 
 
 override func viewDidLoad() {
    
     
     self.viewControllers = [produceVC,marketVC,userVC]
     self.viewControllers?.forEach({$0.tabBarController?.tabBar.barStyle = .default})
 }
 */
