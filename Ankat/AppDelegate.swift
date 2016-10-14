//
//  AppDelegate.swift
//  Ankat
//
//  Created by Eduardo Irías on 7/6/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import UIKit
import Parse
import Bolts
//import ParseFacebookUtilsV4
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("6eN8NWWnwINf4vhn0rmN4Hxg0yaZl5gADgixJ3RK",
            clientKey: "ycQe9mCrQp02Zi3OjeFXvj9AiQOc2EvXkzyjLPnv")
        
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)

        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
   
        let newNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        
        Offer.registerSubclass()
        Subcategory.registerSubclass()
        Preference.registerSubclass()
        
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UITabBar.appearance().tintColor = UIColor().appGreenColor()
        
        /*
        if PFUser.currentUser() == nil {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("changeToMainScreen"), name:"changeToMainScreen", object: nil)

            //loginViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("loginNavViewController") as! UINavigationController
            
            self.window?.rootViewController = viewController
            
        }
        */
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // TODO:
        //let alert = UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: self, cancelButtonTitle: "Awesome!")
        //alert.show()
    }
    
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    //MARK: screens
    
    func changeToMainScreen () {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changeToMainScreen"), object: nil)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "mainController") as! UITabBarController
        self.window?.rootViewController = viewController
    }
    
    //
}

