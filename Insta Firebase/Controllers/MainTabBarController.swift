//
//  MainTabBarController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/23/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil{
//             Show this if the user is not logged in
            
            DispatchQueue.main.async {
                let logInController = LoginController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        
       setUpControllers()
    }
    
    func setUpControllers(){
        
        
        //Home
        let homeController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: UIViewController())
        
        //Search
        let searchController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        
        //Like
        let likeController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //Camera
        let plusController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        // UserProfile
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        let userNavController = UINavigationController(rootViewController: userProfileController)
        
        userNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeController,
                           searchController,
                           likeController,
                           plusController,
                           userNavController]
        
        guard let items = tabBar.items else{return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    fileprivate func tabBarControllers(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController{
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
