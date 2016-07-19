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
    
    @IBOutlet weak var writingSegment: UISegmentedControl!
    @IBOutlet weak var drawingSegment: UISegmentedControl!
    @IBOutlet weak var throwing: UISegmentedControl!
    @IBOutlet weak var scissorsSegment: UISegmentedControl!
    @IBOutlet weak var toothbrushSegment: UISegmentedControl!
    @IBOutlet weak var knifeSegment: UISegmentedControl!
    @IBOutlet weak var spoonSegment: UISegmentedControl!
    @IBOutlet weak var broomSegment: UISegmentedControl!
    @IBOutlet weak var matchSegment: UISegmentedControl!
    @IBOutlet weak var lidSegment: UISegmentedControl!
    
    @IBOutlet weak var childTableView: UITableView!
    @IBOutlet weak var childAgeTextField: UITextField!
    @IBOutlet weak var childGenderTextField: UITextField!
    
    @IBOutlet weak var marriedMonths: UITextField!
    @IBOutlet weak var marriedYears: UITextField!
    @IBOutlet weak var livingMonths: UITextField!
    @IBOutlet weak var livingYears: UITextField!
    @IBOutlet weak var separateMonths: UITextField!
    @IBOutlet weak var separateYears: UITextField!
    
    @IBOutlet weak var childrenView: UIView!
    
    var pickOption = ["Male", "Female", "Other"]
    var step = 1
    var totalSteps = 17
    var progress : Float {
        get {
            return Float(step) / Float(totalSteps)
        }
    }
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var postValues = [String](count: 10, repeatedValue: "")
    var strongHand = String()
    var childPickOption = ["Male", "Female"]
    var ages = [String]()
    var sexes = [String]()
    
    let textCellIdentifier = "ChildTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.progress = progress
        progressLabel.text = "PROGRESS (\(step)/\(totalSteps))"
        
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
        
        // Hand Dominate
//        writingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        drawingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        throwing.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        scissorsSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        toothbrushSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        knifeSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        spoonSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        broomSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        matchSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
//        lidSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
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
    
    func segmentChanged(sender: UISegmentedControl) {
        var hand = String()
        
        if(sender.selectedSegmentIndex == 0) {
            hand = "L"
        } else if(sender.selectedSegmentIndex == 1) {
            hand = "R"
        }
        postValues.removeAtIndex(sender.tag)
        postValues.insert(hand, atIndex: sender.tag)
        
        print(postValues)
        
        var lefty = 0
        var righty = 0
        
        for hand in postValues {
            if (hand == "L") {
                lefty += 1
            } else if (hand == "R") {
                righty += 1
            }
        }
        
        if (lefty > righty) {
            strongHand = "L"
        } else {
            strongHand = "R"
        }
        
        print(strongHand)
    }
    
    @IBAction func changeStatus(sender: AnyObject) {
        switch sender.tag {
        case 0, 3:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        case 1:
            marriedMonths.hidden = false
            marriedYears.hidden = false
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        case 2:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = false
            livingYears.hidden = false
            separateMonths.hidden = true
            separateYears.hidden = true
        case 4:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = false
            separateYears.hidden = false
        default:
            marriedMonths.hidden = true
            marriedYears.hidden = true
            livingMonths.hidden = true
            livingYears.hidden = true
            separateMonths.hidden = true
            separateYears.hidden = true
        }
    }
    
    @IBAction func haveChildren(sender: AnyObject) {
        if (sender.selectedSegmentIndex == 0) {
            childrenView.hidden = false
        } else if (sender.selectedSegmentIndex == 1) {
            childrenView.hidden = true
            ages.removeAll()
            sexes.removeAll()
            childTableView.reloadData()
            childAgeTextField.text = ""
            childGenderTextField.text = ""
        }
    }
    
    @IBAction func addChild(sender: AnyObject) {
        ages.append(childAgeTextField.text!)
        sexes.append(childGenderTextField.text!)
        
        childTableView.reloadData()
        
        childAgeTextField.text = ""
        childGenderTextField.text = ""
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
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ChildTableViewCell
        
        let row = indexPath.row
        cell.ageLabel?.text = String(ages[row])
        cell.sexLabel?.text = sexes[row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(ages[row])
    }
}
