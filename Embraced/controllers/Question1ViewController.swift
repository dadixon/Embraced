//
//  Question1ViewController.swift
//  Embraced
//
//  Created by Domonique Dixon on 8/20/16.
//  Copyright © 2016 Domonique Dixon. All rights reserved.
//

import UIKit
import Stormpath

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
    
    let prefs = UserDefaults.standard
    
    var postValues = [String](repeating: "", count: 10)
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(Question1ViewController.next(_:)))
        
        writingSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        drawingSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        throwing.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        scissorsSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        toothbrushSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        knifeSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        spoonSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        broomSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        matchSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        lidSegment.addTarget(self, action: #selector(segmentChanged), for: UIControlEvents.valueChanged)
        
//        self.childrenTopHighConstraint.constant = 8.0
        
//        togetherPartner.isHidden = true
//        separatedPartner.isHidden = true
//        childView.isHidden = true
//        
//        childrenTableView.delegate = self
//        childrenTableView.dataSource = self
        
//        let nib = UINib(nibName: "ChildTableViewCell", bundle: nil)
//        childrenTableView.register(nib, forCellReuseIdentifier: "ChildTableViewCell")
//        
//        self.martialStatusHeightConstriant.constant = martialStatusInitHeight
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segmentChanged(_ sender: UISegmentedControl) {
        var hand = String()
        
        if(sender.selectedSegmentIndex == 0) {
            hand = "L"
        } else if(sender.selectedSegmentIndex == 1) {
            hand = "R"
        }
        postValues.remove(at: sender.tag)
        postValues.insert(hand, at: sender.tag)
        
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
    
    @IBAction func next(_ sender: AnyObject) {
        var jsonObject = [String: AnyObject]()
            
        // Gather data for post
        if let id = prefs.string(forKey: "pid") {
            print("PID: " + id)
                
            jsonObject = [
                "id": id as AnyObject,
                "dob": dobTextField.text! as AnyObject,
                "gender": genderTextField.text! as AnyObject,
                "hand_dominate": postValues as AnyObject
            ]
        } else {
            // Nothing stored in NSUserDefaults yet. Set a value.
            prefs.setValue("pid", forKey: "pid")
        }
            
        print(jsonObject)
        
        // Push to API
        let notesEndpoint = NSURL(string: Stormpath.sharedSession.configuration.APIURL.absoluteString + "/insert_participant")!
        let request = NSMutableURLRequest(url: notesEndpoint as URL)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
        request.setValue("application/json" , forHTTPHeaderField: "Content-Type")
            
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        
        task.resume()
            
        var navigationArray = self.navigationController?.viewControllers
            
        navigationArray?.remove(at: 0)
            
        let question2ViewController:Question2ViewController = Question2ViewController()
        navigationArray?.append(question2ViewController)
            
        self.navigationController?.setViewControllers(navigationArray!, animated: true)
    }

    @IBAction func textFieldEditing(_ sender: UITextField) {
        if (sender.isEqual(dobTextField)) {
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePickerMode.date
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Question1ViewController.doneDatePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            sender.inputView = datePickerView
            sender.inputAccessoryView = toolBar
            
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        } else if (sender.isEqual(genderTextField)) {
            let pickerView = UIPickerView()
            
            pickerView.delegate = self
            
            genderTextField.inputView = pickerView
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Question1ViewController.donePicker))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            
            toolBar.setItems([spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            
            genderTextField.inputView = pickerView
            genderTextField.inputAccessoryView = toolBar
        }
    }
    
    
    @IBAction func ethnicityChange(_ sender: UISwitch) {
        ethnicitySpecifics.isHidden = true
        ethnicity = ""
        
        switch sender.tag {
        case 0:
            if sender.isOn {
                ethnicity = "No"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 1:
            if sender.isOn {
                ethnicity = "Mexican, Mexican American, Chicano"
                
                notHispanicSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 2:
            if sender.isOn {
                ethnicity = "Puerto Rican"
                
                mexicanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 3:
            if sender.isOn {
                ethnicity = "Cuban"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 4:
            if sender.isOn {
                ethnicity = "Central America"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                otherSpanishSwitch.setOn(false, animated: true)
            }
        case 5:
            if sender.isOn {
                ethnicity = "other"
                
                mexicanSwitch.setOn(false, animated: true)
                puertoRicanSwitch.setOn(false, animated: true)
                cubanSwitch.setOn(false, animated: true)
                centralAmericaSwitch.setOn(false, animated: true)
                notHispanicSwitch.setOn(false, animated: true)
                ethnicitySpecifics.isHidden = false
            } else {
                ethnicitySpecifics.isHidden = true
            }
            
        default:
            ethnicity = ""
            ethnicitySpecifics.isHidden = true
        }
        
        print("\(ethnicity)")
    }
    
    @IBAction func raceChange(_ sender: UISwitch) {
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
    
    func raceArrayEdits(_ name: String, switchObject: UISwitch) {
        if switchObject.isOn {
            race.append(name)
        } else {
            if race.contains(name) {
                race.remove(at: race.index(of: name)!)
            }
        }
    }
    
    @IBAction func martialStatusChange(_ sender: UISwitch) {
        martialStatus = ""
        togetherPartner.isHidden = true
        separatedPartner.isHidden = true
        
        switch sender.tag {
        case 0:
            if sender.isOn {
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
            if sender.isOn {
                martialStatus = "Married"
                togetherPartner.isHidden = false
                
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
            if sender.isOn {
                martialStatus = "Partner"
                togetherPartner.isHidden = false
                
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
            if sender.isOn {
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
            if sender.isOn {
                martialStatus = "Separated"
                separatedPartner.isHidden = false
                
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
            togetherPartner.isHidden = true
            separatedPartner.isHidden = true
        }
    }
    
    @IBAction func addChild(_ sender: AnyObject) {
        ages.append(childAgeTextField.text!)
        sexes.append(childGenderTextField.text!)
        
        childrenTableView.reloadData()
        
        childAgeTextField.text = ""
        childGenderTextField.text = ""
    }
    
    @IBAction func haveChildren(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            self.childView.isHidden = false
            isHasChildren = true
            
            if isSubMartialStatus {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight + martialStatusChildrenHeight
            } else {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusChildrenHeight
            }
            
        } else if(sender.selectedSegmentIndex == 1) {
            self.childView.isHidden = true
            isHasChildren = false
            
            if isSubMartialStatus {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight + martialStatusSubHeight
            } else {
                self.martialStatusHeightConstriant.constant = martialStatusInitHeight
            }
        }
    }
    
    
    
    
    // Mark: Delegate
    
    func doneDatePicker(_ sender: UIDatePicker) {
        dobTextField.resignFirstResponder()
    }
    
    func donePicker(_ sender: UIPickerView) {
        genderTextField.resignFirstResponder()
    }
    
    func datePickerValueChanged(_ sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        dobTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = pickOption[row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! ChildTableViewCell
        
        let row = (indexPath as NSIndexPath).row
        cell.ageLabel?.text = String(ages[row])
        cell.sexLabel?.text = sexes[row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = (indexPath as NSIndexPath).row
        print(ages[row])
    }
}
