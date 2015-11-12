//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MainInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var table: WKInterfaceTable!
    var data: NSArray!
    var session: WCSession
    
    override init(){
        self.session = WCSession.defaultSession()
        super.init()
        self.session.delegate = self
        session.activateSession()
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        
        data = NSArray()
        if (!data.isEqual(nil) || data.count
             > 0){
            self.updateTable()
        } else {
            print("Data is empty")
        }
        // Configure interface objects here.
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        self.data = self.parseJSON(messageData)
        self.updateTable()
    }
    
    func parseJSON(data: NSData?) -> NSArray{
        var parsedData:NSArray!
        do {
            parsedData = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
        } catch {
            print("Error parsing JSON")
        }
        return parsedData
    }
    
    func updateTable(){
        table.setNumberOfRows(self.data.count, withRowType: "WatchListRowController")
        print(table.numberOfRows)
        for (var i = 0; i < table.numberOfRows; i++){
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
