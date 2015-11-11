//
//  ViewController.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/10/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, NetworkRequestorDelegate {

    var data: NSArray!
    var requestor: NetworkRequestor!
    var pasteBoard: UIPasteboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestor = NetworkRequestor()
        self.requestor.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.requestor.getAllStudents()
    }
    
    @IBAction func refresh(sender: UIRefreshControl) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.requestor.getAllStudents()
    }
    
    
    // ------- Table View -------

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("studentCell")!
        if (self.data != nil){
            let dict = self.data![indexPath.row] as! NSDictionary
            let fName = dict["FirstName"] as! String
            let lName = dict["LastName"] as! String
            
            let student = dict["StudentId"] as! String
            let studentId = Int(student)
            
            cell.textLabel?.text = "\(fName) \(lName)"
            cell.tag = studentId!
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.data == nil){
            return 0
        }
        return self.data.count
    }
    
    //--------- Table View Optionals --------
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if( action == Selector("copy:")){
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.editing = false
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action: UITableViewRowAction, indexPath2:NSIndexPath) -> Void in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath2)
            cell?.delete(action)
        }
        return [deleteAction]
    }
    
    override func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let text:String = (cell?.textLabel?.text!)!
        print(text)
        self.pasteBoard = UIPasteboard(name: text, create: true)
        self.pasteBoard.string = text
    }
    
    override func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.editing = true
    }
    
    // ----------- Network Requestor -----------
    
    func noNetworkConnection() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "No Internet Connection", message: "No Internet Connection Found", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            //do nothing
        }
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func retrievedAllStudents(array: NSArray) {
        self.data = array
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    // ----------- Segue ---------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue"){
            let nextView = segue.destinationViewController as! DetailViewController
            let theSender = sender as! UITableViewCell
            let index = self.tableView.indexPathForCell(theSender)
            if (index != nil){
                nextView.data = self.data[index!.row] as! NSDictionary
            } else {
                print("Index error")
            }
        }
    }
    
}

