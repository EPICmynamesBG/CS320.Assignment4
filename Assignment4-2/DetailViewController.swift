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
        let tap = UITapGestureRecognizer(target: self, action: "tap:")
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
    
    func tap(sender: UITapGestureRecognizer){
        self.resignAllResponders()
    }
    
    private func resignAllResponders(){
        let subs = self.view.subviews
        for (var i = 0; i < subs.count; i++){
            subs[i].resignFirstResponder()
        }
        self.yearPickerView.hidden = true
        self.pickerDoneButton.hidden = true
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
    
    private func dataIsDifferent() -> Bool {
        let newFName = self.firstName.text
        let oldFName = self.data["FirstName"] as! String
        if (newFName != oldFName){
            return true
        }
        let newLName = self.lastName.text
        let oldLName = self.data["LastName"] as! String
        if (newLName != oldLName){
            return true
        }
        let newMajor = self.majorTextfield.text
        let oldMajor = self.data["Major"] as! String
        if (newMajor != oldMajor){
            return true
        }
        let newGPA = self.gpaTextfield.text
        let oldGPA = self.data["GPA"] as! String
        if (newGPA != oldGPA){
            return true
        }
        let newYear = self.yearTextfield.text
        let oldYear = self.data["Year"] as! String
        if (newYear != oldYear){
            return true
        }
        return false
    }
    
    private func allFieldsAreFilled() -> Bool{
        var textFieldsArray = Array<String>()
        textFieldsArray.append(String(self.firstName.text))
        textFieldsArray.append(String(self.lastName.text))
        textFieldsArray.append(String(self.majorTextfield.text))
        textFieldsArray.append(String(self.gpaTextfield.text))
        textFieldsArray.append(String(self.yearTextfield.text))
        for (var i = 0; i < textFieldsArray.count; i++) {
            let str: String = textFieldsArray[i]
            if (str.isEmpty || str == ""){
                return false
            }
        }
        return true
    }
    
    // ------ Button Taps ----------
    @IBAction func yearTextButton(sender: UIButton) {
        self.yearPickerView.hidden = false
        self.pickerDoneButton.hidden = false
        self.yearPickerView.becomeFirstResponder()
        self.resignRespondersExceptFor(self.yearPickerView)
    }
    
    @IBAction func submitChangesTap(sender: UIButton) {
        self.resignAllResponders()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if (self.createStudentMode == true){
            //create new student
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if (self.allFieldsAreFilled() == true){
                let params: String = "FirstName=\(String(UTF8String: self.firstName.text!)!)&LastName=\(String(UTF8String: self.lastName.text!)!)&Major=\(String(UTF8String: self.majorTextfield.text!)!)&Year=\(String(UTF8String: self.yearTextfield.text!)!)&GPA=\(String(UTF8String: self.gpaTextfield.text!)!)"
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                self.requestor.createStudent(params)
            } else {
                let newAlert = UIAlertController(title: "Input Error", message: "Invalid inputs. Check that at least one field has changed and all are filled.", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                    //do nothing
                }
                newAlert.addAction(cancel)
                self.presentViewController(newAlert, animated: true, completion: nil)
            }
        } else {
            //modify current student
            let id = self.data["StudentId"] as? String
            let studentId:Int = Int(id!)!
            let alert = UIAlertController(title: "Confirm Update", message: "Are you sure you want to commit these changes?", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                //do nothing
            }
            let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action:UIAlertAction) -> Void in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                if (self.dataIsDifferent() == true && self.allFieldsAreFilled() == true){
                    let params: String = "FirstName=\(String(UTF8String: self.firstName.text!)!)&LastName=\(String(UTF8String: self.lastName.text!)!)&Major=\(String(UTF8String: self.majorTextfield.text!)!)&Year=\(String(UTF8String: self.yearTextfield.text!)!)&GPA=\(String(UTF8String: self.gpaTextfield.text!)!)"
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    self.requestor.updateStudent(studentId, withData: params)
                } else {
                    let newAlert = UIAlertController(title: "Input Error", message: "Invalid inputs. Check that at least one field has changed and all are filled.", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                        //do nothing
                    }
                    newAlert.addAction(cancel)
                    self.presentViewController(newAlert, animated: true, completion: nil)
                }
                
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func resetChangesTap(sender: UIButton) {
        self.resignAllResponders()
        self.loadInitialData()
    }
    
    @IBAction func deleteStudentTap(sender: UIButton) {
        self.resignAllResponders()
        let id = self.data["StudentId"] as? String
        let studentId:Int = Int(id!)!
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this student?", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = UILabel()
        let text = self.pickerData[row]
        if (pickerLabel.isEqual(nil) || !pickerLabel.isMemberOfClass(UILabel)){
            let frame = CGRectMake(0, 0, 270, 32)
            pickerLabel = UILabel(frame: frame)
        }
        pickerLabel.textAlignment = .Center
        pickerLabel.backgroundColor = UIColor.clearColor()
        pickerLabel.font = UIFont(name: "Avenir Next Bold", size: 18)
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = text
        return pickerLabel
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
                self.navigationController?.popViewControllerAnimated(true)
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        if (boolean){
            let alert = UIAlertController(title: "Student Created", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            }
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Creation Failed", message: "Student could not be created", preferredStyle: UIAlertControllerStyle.Alert)
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action:UIAlertAction) -> Void in
                //do nothing
            }
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
