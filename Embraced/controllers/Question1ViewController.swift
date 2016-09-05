//
//  Question1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import ISRadioButton

class Question1ViewController: FrontViewController, UIPickerViewDataSource, UIPickerViewDelegate {

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
    
    @IBOutlet weak var notHispanic: ISRadioButton!
    
    var pickOption = ["Male", "Female", "Other"]
    var step = 1
    var totalSteps = 3
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
        progressLabel.text = "Progress (\(step)/\(totalSteps))"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(next))
        
        writingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        drawingSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        throwing.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        scissorsSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        toothbrushSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        knifeSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        spoonSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        broomSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        matchSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        lidSegment.addTarget(self, action: #selector(segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: Actions

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
                    "gender": genderTextField.text!,
                    "hand_dominate": postValues
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
            
            
//            var navigationArray = self.navigationController?.viewControllers
//            
//            navigationArray?.removeAtIndex(0)
//            
//            let question2ViewController:Question2ViewController = Question2ViewController()
//            navigationArray?.append(question2ViewController)
//            
//            self.navigationController?.setViewControllers(navigationArray!, animated: true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill all the required fields.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }

    @IBAction func textFieldEditing(sender: UITextField) {
        if (sender.isEqual(dobTextField)) {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.Date
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.Default
            toolBar.translucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(Question1ViewController.doneDatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            sender.inputView = datePickerView
            sender.inputAccessoryView = toolBar
            
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        } else if (sender.isEqual(genderTextField)) {
            let pickerView = UIPickerView()
            
            pickerView.delegate = self
            
            genderTextField.inputView = pickerView
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.Default
            toolBar.translucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(Question1ViewController.donePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.userInteractionEnabled = true
            
            genderTextField.inputView = pickerView
            genderTextField.inputAccessoryView = toolBar
        }
        
    }
    
    @IBAction func logSelectedButton(isRadioButton:ISRadioButton){
        if isRadioButton.multipleSelectionEnabled{
            for radioButton in isRadioButton.otherButtons! {
                print("%@ is selected.\n", radioButton.titleLabel!.text);
            }
        }else{
            print("%@ is selected.\n", isRadioButton.titleLabel!.text);
        }
    }
    
    
    // Mark: Delegate
    
    func doneDatePicker(sender: UIDatePicker) {
        dobTextField.resignFirstResponder()
    }
    
    func donePicker(sender: UIPickerView) {
        genderTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
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
