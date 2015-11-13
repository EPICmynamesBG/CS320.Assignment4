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
        if (WCSession.isSupported()){
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(NSTimeInterval(backgroundRefreshTime))
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("Fetching...")
        let fetchedArray = self.requestor.getAllStudentsInFetch()
        let savedArray = SaveDataManager.getJSON()
        print(fetchedArray.debugDescription)
        print(savedArray.debugDescription)
        let notification = Notification()
        notification.fireNotification()
        if (fetchedArray != nil){
            if (savedArray != nil){
                if (fetchedArray! == savedArray!){
                    print("Success")
                    let notification = Notification()
                    notification.fireNotification()
                    completionHandler(.NewData)
                } else {
                    print("Data is same")
                    completionHandler(.NoData)
                }
            } else {
                SaveDataManager.saveJSON(fetchedArray!)
                print("saved data was nil")
                completionHandler(.NoData)
            }
        } else {
            print("Failed")
            completionHandler(.Failed)
        }
    }

}

