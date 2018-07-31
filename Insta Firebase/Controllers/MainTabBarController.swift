//
//  MainTabBarController.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/23/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        if index == 2{
            let photSelectorController = PhotoSelectorcontroller(collectionViewLayout: UICollectionViewFlowLayout())
            let photoSelectNavController = UINavigationController(rootViewController: photSelectorController)
            present(photoSelectNavController, animated: true, completion: nil)
            return false
            
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.delegate = self
        
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
        let homeController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Search
        let searchController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"))
        
        //Like
        let likeController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        //Camera
        let plusController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        // UserProfile
        let userProfileController = tabBarControllers(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = .black
        
        viewControllers = [homeController,
                           searchController,
                           plusController,
                           likeController,
                           userProfileController]
        
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
