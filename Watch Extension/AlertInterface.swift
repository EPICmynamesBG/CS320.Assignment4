//
//  AlertInterface.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/13/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit

class AlertInterface : WKUserNotificationInterfaceController {
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var bodyLabel: WKInterfaceLabel!
    
    override func handleActionWithIdentifier(identifier: String?, forLocalNotification localNotification: UILocalNotification) {
        WKInterfaceDevice().playHaptic(WKHapticType.Notification)
        titleLabel.setText(localNotification.alertTitle)
        bodyLabel.setText(localNotification.alertBody)
    }
    
}
