//
//  QuestionnaireViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 6/16/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath

class QuestionnaireViewController: FrontViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    var pickOption = ["Male", "Female", "Other"]
    var step = 1
    var progress : Float {
        get {
            return Float(step) / 17.0
        }
    }
    let prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = progress
        progressLabel.text = "Progress (\(step)/17)"
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        genderTextField.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QuestionnaireViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        genderTextField.inputView = pickerView
        genderTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func textFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(QuestionnaireViewController.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = toolBar
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
        if (!(dobTextField.text?.isEmpty)! && !(genderTextField.text?.isEmpty)!) {
            print("Good to go")
            var jsonObject = [String: AnyObject]()
            
            // Gather data for post
            if let id = prefs.stringForKey("pid") {
                print("PID: " + id)
                
                jsonObject = [
                    "id": id,
                    "dob": dobTextField.text!,
                    "gender": genderTextField.text!
                ]
            } else {
                // Nothing stored in NSUserDefaults yet. Set a value.
                prefs.setValue("pid", forKey: "pid")
            }
            
            print(jsonObject)
            
            // Push to API
//            let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_participant")!
//            let request = NSMutableURLRequest(URL: notesEndpoint)
//            request.HTTPMethod = "POST"
//            request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(jsonObject, options: [])
//            request.setValue("application/json" ?? "", forHTTPHeaderField: "Content-Type")
//            
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
//            task.resume()
            
            let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("HandDominateViewController") as! HandDominateViewController
            self.navigationController!.pushViewController(VC1, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill all the fields.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    // MARK: Delegate
    
    func doneDatePicker(sender: UIDatePicker) {
        dobTextField.resignFirstResponder()
    }
    
    func donePicker(sender: UIPickerView) {
        genderTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
    
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dobTextField.text = dateFormatter.stringFromDate(sender.date)
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = pickOption[row]
    }
}
