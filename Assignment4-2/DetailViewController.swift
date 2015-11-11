//
//  DetailViewController.swift
//  Assignment4-2
//
//  Created by Brandon Groff on 11/10/15.
//  Copyright © 2015 Brandon Groff. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, NetworkRequestorDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var data: NSDictionary!
    var requestor: NetworkRequestor!
    var createStudentMode: Bool! = false
    var pickerData = ["Freshman", "Sophomore", "Junior", "Senior"]
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var majorTextfield: UITextField!
    @IBOutlet weak var gpaTextfield: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!
    @IBOutlet weak var yearPickerView: UIPickerView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pickerDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.data == nil){
            createStudentMode = true
        } else {
            createStudentMode = false
        }
        let tap = UITapGestureRecognizer(target: self, action: Selector(self.resignAllResponders()))
        self.view.addGestureRecognizer(tap)
        self.requestor = NetworkRequestor()
        self.requestor.delegate = self
        self.prepareViews()
    }
    
    private func prepareViews(){
        self.yearPickerView.hidden = true
        self.pickerDoneButton.hidden = true
        if (self.createStudentMode == true){
            self.navigationItem.title = "New Student"
            self.resetButton.hidden = true
            self.deleteButton.hidden = true
        } else {
            self.loadInitialData()
        }
    }
    
    private func loadInitialData(){
        let fName = self.data["FirstName"] as? String
        let lName = self.data["LastName"] as? String
        self.navigationItem.title = "\(fName!) \(lName!)"
        self.firstName.text = fName
        self.lastName.text = lName
        let id = self.data["StudentId"] as! String
        self.studentIdLabel.text = "Student ID: \(id)"
        self.majorTextfield.text = self.data["Major"] as? String
        self.gpaTextfield.text = self.data["GPA"] as? String
        self.yearTextfield.text = self.data["Year"] as? String
        var index:Int = 0
        for (var i = 0; i < self.pickerData.count; i++) {
            let string = self.data["Year"] as! String
            if (self.pickerData[i] == string){
                index = i
            }
        }
        self.yearPickerView.selectRow(index, inComponent: 0, animated: false)
    }
    
    private func resignAllResponders(){
        let subs = self.view.subviews
        for (var i = 0; i < subs.count; i++){
            subs[i].resignFirstResponder()
        }
    }
    
    private func resignRespondersExceptFor(view: UIView){
        let subs = self.view.subviews
        for (var i = 0; i < subs.count; i++){
            if (subs[i] == view){
                //skip
            } else {
                subs[i].resignFirstResponder()
            }
        }
    }
    
    // ------ Button Taps ----------
    @IBAction func yearTextButton(sender: UIButton) {
        self.yearPickerView.hidden = false
        self.pickerDoneButton.hidden = false
        self.yearPickerView.becomeFirstResponder()
        self.resignRespondersExceptFor(self.yearPickerView)
    }
    
    @IBAction func submitChangesTap(sender: UIButton) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if (self.createStudentMode == true){
            //create new student
        } else {
            //modify current student
        }
    }
    
    @IBAction func resetChangesTap(sender: UIButton) {
        self.loadInitialData()
    }
    
    @IBAction func deleteStudentTap(sender: UIButton) {
        let id = self.data["StudentId"] as? String
        let studentId:Int = Int(id!)!
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "Confirm Update", message: "Are you sure you want to commit these changes?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            //do nothing
        }
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.requestor.deleteStudent(studentId)
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func pickerDoneTap(sender: UIButton) {
        self.yearPickerView.resignFirstResponder()
        self.yearPickerView.hidden = true
        self.pickerDoneButton.hidden = true
    }
    
    // ------- TextFields ---------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    // ------ Picker View ------ 
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.yearTextfield.text = self.pickerData[row]
    }
    
    //----------- Network Requestor --------
    
    func noNetworkConnection() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "No Internet Connection", message: "No Internet Connection Found", preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
            //do nothing
        }
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func rowUpdateSuccessful(boolean: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (boolean){
            let alert = UIAlertController(title: "Update Successful", message: "Student data updated", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                //do nothing
            }
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Update failed", message: "Student data could not be updated", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                //do nothing
            }
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func rowDeletionSuccessful(boolean: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (boolean){
            let alert = UIAlertController(title: "Student Deleted", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Deletion Failed", message: "Student could not be deleted", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                //do nothing
            }
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func rowInsertSuccessful(boolean: Bool) {
        //code
    }
}
