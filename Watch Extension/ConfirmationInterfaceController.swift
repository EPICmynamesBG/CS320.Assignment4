//
//  ConfirmationInterfaceController.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class ConfirmationInterfaceController: WKInterfaceController {
    
    var id: String!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.id = context as! String
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func cancelTap() {
        
    }
    
    @IBAction func deleteTap() {
        
    }
}

