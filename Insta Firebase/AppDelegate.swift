//
//  AppDelegate.swift
//  Insta Firebase
//
//  Created by Viswa Kodela on 7/21/18.
//  Copyright © 2018 Viswa Kodela. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        
        attemptRegisterForNotifications(application: application)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM Token", fcmToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            //Wer have to push the UserProfileController with the followerId
                let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
                userProfileController.userId = followerId
            
            //How do we access our Main UI from AppDelegate ?
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                mainTabBarController.selectedIndex = 0
                
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                    
                }
            }
        }
    }
    
    //Listen for user Notifications
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        
        print("Attempt to register for APNS..")
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        //We have to perform user notification Authorization
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
                if let error = error{
                    print("Failed to request Authorization:", error)
                }
                if granted{
                    print("Auth Granted")
                }
                else{
                    print("Auth Denied")
                }
        }
        
        application.registerForRemoteNotifications()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

