//
//  MainTabBarController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/23/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
