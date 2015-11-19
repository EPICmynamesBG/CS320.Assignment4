//
//  StudentInterfaceController.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class StudentInterfaceController: WKInterfaceController {
    
    var data: NSDictionary!
    
    @IBOutlet var firstNameLabel: WKInterfaceLabel!
    @IBOutlet var lastNameLabel: WKInterfaceLabel!
    @IBOutlet var studentIdLabel: WKInterfaceLabel!
    @IBOutlet var majorLabel: WKInterfaceLabel!
    @IBOutlet var yearLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let dict = context as! NSDictionary
        self.data = dict
        self.firstNameLabel.setText((dict["FirstName"] as! String))
        self.lastNameLabel.setText((dict["LastName"] as! String))
        let id = dict["StudentId"] as! String
        let studentId = "Student ID: \(id)"
        self.studentIdLabel.setText(studentId)
        self.majorLabel.setText((dict["Major"] as! String))
        self.yearLabel.setText((dict["Year"] as! String))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        if (segueIdentifier == "confirmationSegue"){
            let id = self.data["StudentId"] as! String
            self.pushControllerWithName("ConfirmationInterfaceController", context: id)
            return id
        }
        return nil
    }
    
}
