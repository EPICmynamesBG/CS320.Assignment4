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
    let title: String = ""
    let body: String = ""
    
    override init() {
        self.notification = UILocalNotification()
        self.notification.timeZone = NSTimeZone.localTimeZone()
        self.notification.alertBody = body
        self.notification.alertTitle = title
    }
    
    func fireNotification(){
        //let time = NSDate.init(timeIntervalSinceNow: NSTimeInterval(30))
        let time = NSDate.init()
        self.notification.fireDate = time
    }
}