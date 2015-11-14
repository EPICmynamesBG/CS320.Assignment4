//
//  Notification.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/13/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import Foundation
import UIKit

class Notification: NSObject {
    
    let title: String = "Student Data Changed"
    let body: String = "Student data has changed!"
    
    override init() {
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = body
        notification.alertTitle = title
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = 1
        let time = NSDate.init(timeIntervalSinceNow: NSTimeInterval(5))
        notification.fireDate = time
        #if os(iOS)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        #endif
    }
    
}