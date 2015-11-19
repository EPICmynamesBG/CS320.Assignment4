//
//  ConfirmationInterfaceController.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation

class ConfirmationInterfaceController: WKInterfaceController, NetworkRequestorDelegate {
    
    @IBOutlet var confirmLabel: WKInterfaceLabel!
    @IBOutlet var deletedLabel: WKInterfaceLabel!
    
    @IBOutlet var cancelButton: WKInterfaceButton!
    @IBOutlet var deleteButton: WKInterfaceButton!
    @IBOutlet var okButton: WKInterfaceButton!
    
    var id: String!
    var requestor: NetworkRequestor = NetworkRequestor()
    var deleteSuccess: Bool = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.id = context as! String
        self.requestor.delegate = self
        
        self.deletedLabel.setHidden(true)
        self.okButton.setHidden(true)
        // Configure interface objects here.
    }
    
    // --------- Button Taps -----------
    
    @IBAction func cancelTap() {
        self.popController()
    }
    
    @IBAction func deleteTap() {
        self.confirmLabel.setHidden(true)
        self.cancelButton.setHidden(true)
        self.deleteButton.setHidden(true)
        let studentId = Int(id)
        self.requestor.deleteStudent(studentId!)
    }
    
    @IBAction func okTap() {
        if (self.deleteSuccess == true){
            self.popToRootController()
        } else {
            self.popController()
        }
    }
    
    // --------- Connection Delegates ---------
    
    func noPhoneConnected() {
        self.deleteSuccess = false
        self.deletedLabel.setText("No Network Connection")
        self.deletedLabel.setTextColor(UIColor.redColor())
        self.deletedLabel.setHidden(false)
        self.okButton.setHidden(false)
    }
    
    func rowDeletionSuccessful(boolean: Bool) {
        self.deleteSuccess = boolean
        PostDelete.deletionMade = boolean
        if (self.deleteSuccess == true){
            self.deletedLabel.setText("Deleted")
            let greenColor = UIColor(red: 4, green: 222, blue: 113, alpha: 1.0)
            self.deletedLabel.setTextColor(greenColor)
        } else {
            self.deletedLabel.setText("Error: Student not deleted.")
            self.deletedLabel.setTextColor(UIColor.redColor())
        }
        self.deletedLabel.setHidden(false)
        self.okButton.setHidden(false)
    }
}

