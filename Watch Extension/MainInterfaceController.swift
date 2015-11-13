//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Brandon Groff on 11/11/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import WatchKit
import Foundation


class MainInterfaceController: WKInterfaceController, NetworkRequestorDelegate {

    @IBOutlet var loadingLabel: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var noNetworkLabel: WKInterfaceLabel!
    
    @IBOutlet var retryButton: WKInterfaceButton!
    
    var data: NSArray!
    var requestor: NetworkRequestor = NetworkRequestor()
    var makingRequest: Bool = false
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.setTitle("Students")
        data = NSArray()
        self.requestor.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable", name: "DataDidUpdate", object: nil)
        // Configure interface objects here.
    }
    
    func updateTable(){
        table.setNumberOfRows(self.data.count, withRowType: "WatchListRowController")
        for (var i = 0; i < table.numberOfRows; i++){
            let dict = self.data[i] as! NSDictionary
            let row = table.rowControllerAtIndex(i) as! WatchListRowController
            let fName = dict["FirstName"] as! String
            let lName = dict["LastName"] as! String
            let str = "\(fName) \(lName)"
            row.studentLabel.setText(str)
            
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        self.makingRequest = true
        self.requestor.getAllStudents()
        if (makingRequest){
            self.loadingLabel.setHidden(false)
        }
        
    }
    @IBAction func reloadTap() {
        self.makingRequest = true
        table.setNumberOfRows(0, withRowType: "WatchListRowController")
        self.data = []
        self.requestor.getAllStudents()
        if (makingRequest){
            self.loadingLabel.setHidden(false)
        }
    }

    @IBAction func retryTap() {
        self.makingRequest = true
        if (makingRequest){
            self.loadingLabel.setHidden(false)
            self.noNetworkLabel.setHidden(true)
            self.retryButton.setHidden(true)
        }
        self.requestor.getAllStudents()
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if (segueIdentifier == "showStudentSegue"){
            let dict = self.data[rowIndex] as! NSDictionary
            self.pushControllerWithName("StudentInterfaceController", context: dict)
            return dict
        }
        return nil
    }
    
    func noNetworkConnection() {
        print("No connection")
        self.makingRequest = false
        self.noNetworkLabel.setHidden(false)
        self.retryButton.setHidden(false)
    }
    
    func retrievedAllStudents(array: NSArray) {
        self.data = array
        self.makingRequest = false
        self.updateTable()
        if (!makingRequest){
            self.loadingLabel.setHidden(true)
            self.noNetworkLabel.setHidden(true)
            self.retryButton.setHidden(true)
        }
    }

}