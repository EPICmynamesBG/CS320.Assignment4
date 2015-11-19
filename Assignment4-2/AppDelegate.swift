//
//  AppDelegate.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/10/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    let backgroundRefreshTime: Int = 60 * 60 //60 seconds * 60 minutes = 1 hr
    let requestor = NetworkRequestor()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Watch
        if (WCSession.isSupported()){
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        //background fetching
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(NSTimeInterval(backgroundRefreshTime))
        
        //notifications
        application.applicationIconBadgeNumber = 0
        
        let settings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        //Nav Bar
        let color = UIColor.whiteColor()
        let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: UIFont(name: "Avenir Next Heavy", size: 18)!]
        //customize the nav bar title
        UINavigationBar.appearance().titleTextAttributes = attributes
        //customize bar buttons
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
        //change back button color
        UINavigationBar.appearance().tintColor = color
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        let fetchedArray = self.requestor.getAllStudentsInFetch()
        let savedArray = SaveDataManager.getJSON()
        if (fetchedArray != nil){
            if (savedArray != nil){
                if (!NSArrayCompare.arraysAreEqual(fetchedArray!, array2: savedArray!)){
                    //Notification created
                    _ = Notification.init()
                    completionHandler(.NewData)
                } else {
                    //data is same
                    completionHandler(.NoData)
                }
            } else {
                //saved data was nil
                completionHandler(.NoData)
            }
            SaveDataManager.saveJSON(fetchedArray!)
        } else {
            //fetch failed
            completionHandler(.Failed)
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //response to local notification. Nothing needs done though
    }
}

