//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    var data: NSArray!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if (!data.isEqual(nil)){
            self.updateTable()
        } else {
            print("Data is nil")
        }
        // Configure interface objects here.
    }
    
    func updateTable(){
        table.setNumberOfRows(self.data.count, withRowType: "WatchListRowController")
        for (var i = 0; i < self.data.count; i++){
            let dict = self.data[i] as! NSDictionary
            let cell = table.rowControllerAtIndex(i) as! WatchListRowController
            let fName = dict["FirstName"] as! String
            let lName = dict["LastName"] as! String
            let str = "\(fName) \(lName)"
            cell.studentLabel.setText(str)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if (segueIdentifier == "showStudentSegue"){
            let dict = self.data[rowIndex] as! NSDictionary
            self.pushControllerWithName("StudentInterfaceController", context: dict)
            return dict
        }
        return nil
    }

}
