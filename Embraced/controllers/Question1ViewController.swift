//
//  Question1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit

class Question1ViewController: FrontViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {

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
    
    @IBOutlet weak var notHispanicSwitch: UISwitch!
    @IBOutlet weak var mexicanSwitch: UISwitch!
    @IBOutlet weak var puertoRicanSwitch: UISwitch!
    @IBOutlet weak var cubanSwitch: UISwitch!
    @IBOutlet weak var centralAmericaSwitch: UISwitch!
    @IBOutlet weak var otherSpanishSwitch: UISwitch!
    
    @IBOutlet weak var indianSwitch: UISwitch!
    @IBOutlet weak var asianSwitch: UISwitch!
    @IBOutlet weak var blackSwitch: UISwitch!
    @IBOutlet weak var hawaiiSwitch: UISwitch!
    @IBOutlet weak var whiteSwitch: UISwitch!
    
    @IBOutlet weak var ethnicitySpecifics: UITextField!
    
    @IBOutlet weak var singleSwitch: UISwitch!
    @IBOutlet weak var marriedSwitch: UISwitch!
    @IBOutlet weak var partnerSwitch: UISwitch!
    @IBOutlet weak var widowSwitch: UISwitch!
    @IBOutlet weak var separatedSwitch: UISwitch!
    @IBOutlet weak var childrenTopHighConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var togetherPartner: UIView!
    @IBOutlet weak var separatedPartner: UIView!
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var childrenTableView: UITableView!
    @IBOutlet weak var childAgeTextField: UITextField!
    @IBOutlet weak var childGenderTextField: UITextField!
    @IBOutlet weak var martialStatusHeightConstriant: NSLayoutConstraint!
    
    
    
    
    
    
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
    
    var nationality = [String]()
    var ethnicity = String()
    var race = [String]()
    var martialStatus = String()
    
    
    let textCellIdentifier = "ChildTableViewCell"

    var isSubMartialStatus = false
    var isHasChildren = false
    let martialStatusSubHeight = CGFloat(65.0)
    let martialStatusChildrenHeight = CGFloat(248.0)
    let martialStatusInitHeight = CGFloat(290.0)
    let martialStatusMediumHeight = CGFloat(355.0)
    let martialStatusMaxHeight = CGFloat(603.0)
    
    
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
        
        self.childrenTopHighConstraint.constant = 8.0
        
        togetherPartner.hidden = true
        separatedPartner.hidden = true
        childView.hidden = true
        
        childrenTableView.delegate = self
        childrenTableView.dataSource = self
        
        let nib = UINib(nibName: "ChildTableViewCell", bundle: nil)
        childrenTableView.registerNib(nib, forCellReuseIdentifier: "ChildTableViewCell")
        
        self.martialStatusHeightConstriant.constant = martialStatusInitHeight
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
//        if (!(dobTextField.text?.isEmpty)! && !(genderTextField.text?.isEmpty)!) {
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
            
            
        
//        } else {
//            let alert = UIAlertController(title: "Error", message: "Please fill all the required fields.", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//        }
        
        
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
    
    
    @IBAction func ethnicityChange(sender: UISwitch) {
        ethnicitySpecifics.hidden = true
        ethnicity = ""
        
        switch sender.tag {
        case 0:
            if sender.on {
                ethnicity = "No"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 1:
            if sender.on {
                ethnicity = "Mexican, Mexican American, Chicano"
                
                notHispanicSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 2:
            if sender.on {
                ethnicity = "Puerto Rican"
                
                mexicanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 3:
            if sender.on {
                ethnicity = "Cuban"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 4:
            if sender.on {
                ethnicity = "Central America"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 5:
            if sender.on {
                ethnicity = "other"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
            }
            ethnicitySpecifics.hidden = false
        default:
            ethnicity = ""
            ethnicitySpecifics.hidden = true
        }
        
        print("\(ethnicity)")
    }
    
    @IBAction func raceChange(sender: UISwitch) {
        var name = ""
        
        switch sender.tag {
        case 0:
            name = "American Indian"
            
            raceArrayEdits(name, switchObject: sender)
        case 1:
            name = "Asian"
            
            raceArrayEdits(name, switchObject: sender)
        case 2:
            name = "Black"
            
            raceArrayEdits(name, switchObject: sender)
        case 3:
            name = "Native Hawaiian"
            
            raceArrayEdits(name, switchObject: sender)
        case 4:
            name = "White"
            
            raceArrayEdits(name, switchObject: sender)
        default:
            race = [String]()
        }
        
        print("\(race)")
    }
    
    func raceArrayEdits(name: String, switchObject: UISwitch) {
        if switchObject.on {
            race.append(name)
        } else {
            if race.contains(name) {
                race.removeAtIndex(race.indexOf(name)!)
            }
        }
    }
    
    @IBAction func martialStatusChange(sender: UISwitch) {
        martialStatus = ""
        togetherPartner.hidden = true
        separatedPartner.hidden = true
        
        switch sender.tag {
        case 0:
            if sender.on {
                martialStatus = "Single"
                
                marriedSwitch.setOn(false, animated: true)
                partnerSwitch.setOn(false, animated: true)
                widowSwitch.setOn(false, animated: true)
                separatedSwitch.setOn(false, animated: true)
                
                isSubMartialStatus = false
                
                self.childrenTopHighConstraint.constant = 8.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight
                }
            }
        case 1:
            if sender.on {
                martialStatus = "Married"
                togetherPartner.hidden = false
                
                singleSwitch.setOn(false, animated: true)
                partnerSwitch.setOn(false, animated: true)
                widowSwitch.setOn(false, animated: true)
                separatedSwitch.setOn(false, animated: true)
                
                isSubMartialStatus = true
                
                self.childrenTopHighConstraint.constant = 81.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight
                }
                
            } else {
                self.childrenTopHighConstraint.constant = 8.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight
                }
            }
        case 2:
            if sender.on {
                martialStatus = "Partner"
                togetherPartner.hidden = false
                
                marriedSwitch.setOn(false, animated: true)
                singleSwitch.setOn(false, animated: true)
                widowSwitch.setOn(false, animated: true)
                separatedSwitch.setOn(false, animated: true)
                
                isSubMartialStatus = true
                
                self.childrenTopHighConstraint.constant = 81.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight
                }
                
            } else {
                self.childrenTopHighConstraint.constant = 8.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight
                }
            }
        case 3:
            if sender.on {
                martialStatus = "Widow"
                
                marriedSwitch.setOn(false, animated: true)
                partnerSwitch.setOn(false, animated: true)
                singleSwitch.setOn(false, animated: true)
                separatedSwitch.setOn(false, animated: true)
                
                isSubMartialStatus = false
                
                self.childrenTopHighConstraint.constant = 8.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight
                }
            }
        case 4:
            if sender.on {
                martialStatus = "Separated"
                separatedPartner.hidden = false
                
                marriedSwitch.setOn(false, animated: true)
                partnerSwitch.setOn(false, animated: true)
                widowSwitch.setOn(false, animated: true)
                singleSwitch.setOn(false, animated: true)
                
                isSubMartialStatus = true
                
                self.childrenTopHighConstraint.constant = 81.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight
                }
                
            } else {
                self.childrenTopHighConstraint.constant = 8.0
                
                if isHasChildren {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
                } else {
                    self.martialStatusHeightConstriant.constant = martialStatusInitHeight
                }
            }
        default:
            martialStatus = ""
            togetherPartner.hidden = true
            separatedPartner.hidden = true
        }
    }
    
    @IBAction func addChild(sender: AnyObject) {
        ages.append(childAgeTextField.text!)
        sexes.append(childGenderTextField.text!)
        
        childrenTableView.reloadData()
        
        childAgeTextField.text = ""
        childGenderTextField.text = ""
    }
    
    @IBAction func haveChildren(sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            self.childView.hidden = false
            isHasChildren = true
            
            if isSubMartialStatus {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight + martialStatusChildrenHeight
            } else {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
            }
            
        } else if(sender.selectedSegmentIndex == 1) {
            self.childView.hidden = true
            isHasChildren = false
            
            if isSubMartialStatus {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight
            } else {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight
            }
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
