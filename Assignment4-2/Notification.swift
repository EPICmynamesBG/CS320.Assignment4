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
    
    var notification: UILocalNotification!
    let title: String = "Student List Changed"
    let body: String = "See what's changed!"
    
    override init() {
        self.notification = UILocalNotification()
        self.notification.timeZone = NSTimeZone.defaultTimeZone()
        self.notification.alertBody = body
        self.notification.alertTitle = title
        self.notification.soundName = UILocalNotificationDefaultSoundName
        self.notification.applicationIconBadgeNumber = 1
        let time = NSDate.init(timeIntervalSinceNow: NSTimeInterval(5))
        self.notification.fireDate = time
    }
    
    func getNotification() -> UILocalNotification! {
        return self.notification
    }
}